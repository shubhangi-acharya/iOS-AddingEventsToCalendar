//
//  SampleCalender.m
//  Sample
//
//  Created by Shubhangi on 21/05/12.
//  Copyright (c) 2012 Shubhangi. All rights reserved.
//

#import "SampleCalender.h"

static SampleCalender *sharedCal;

@interface SampleCalender()

@end

@implementation SampleCalender

@synthesize eventStore;

+(SampleCalender *) sharedInstance
{
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedCal = [[SampleCalender alloc]init];
    });
    return sharedCal;
}

-(instancetype)init
{
    if(self=[super init]){
        self.eventStore = [[EKEventStore alloc]init];
    }
    return self;
}

-(void)requestCalendarAccessWithCompletion:(CalendarPermisionRequestBlock)completion
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status)
    {
        case EKAuthorizationStatusAuthorized:
        {
            completion(YES, NO, nil);
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        }
        case EKAuthorizationStatusNotDetermined:
        {
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
                completion(granted, YES, [error localizedDescription]);
            }];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        }
        case EKAuthorizationStatusDenied:
        {
            //Status denied
            break;
        }
        case EKAuthorizationStatusRestricted:
        {
            
            completion(NO, NO,  @"Permission Denied");
        }
            break;
        default:
            completion(NO, NO, nil);
            break;
    }
}

-(void)commitAllChanges{
    NSError *commitError;
    BOOL status = [self.eventStore commit:&commitError];
    if(status==NO){
    }
}

-(NSString *)createCalEvent:(NSString *)eventTitle withStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate withNotes:(NSString*)notes withAlarmOffset:(NSTimeInterval)alarmOffset;
{
    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
    event.title = eventTitle;
    event.startDate = startDate;
    event.endDate = endDate;
    event.notes = notes;
    if (!isnan(alarmOffset)) {
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
        event.alarms = @[alarm];
    }
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    NSError *err;
    BOOL status = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    if(status==NO){
    }
    return event.eventIdentifier;
}

-(BOOL)removeEventWithIdentifier:(NSString *)eventIdentifier
{
    EKEvent *event = [self.eventStore eventWithIdentifier:eventIdentifier];
    NSError *error;
    BOOL status = [self.eventStore removeEvent:event span:EKSpanThisEvent error:&error];
    if(status==NO){
    }
    return status;
}

@end