//
//  SampleCalender.h
//  Sample
//
//  Created by Shubhangi on 21/05/12.
//  Copyright (c) 2012 Shubhangi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void (^CalendarPermisionRequestBlock)(BOOL status,BOOL isFirstAccess, NSString *errorMessage);

@interface SampleCalender : NSObject

@property (strong, nonatomic) EKEventStore *eventStore;

+(SampleCalender *) sharedInstance;
-(void)requestCalendarAccessWithCompletion:(CalendarPermisionRequestBlock)completion;
-(void)commitAllChanges;
-(NSString *)createCalEvent:(NSString *)eventTitle withStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate withNotes:(NSString*)notes withAlarmOffset:(NSTimeInterval)alarmOffset;
-(BOOL)removeEventWithIdentifier:(NSString *)eventIdentifier;

@end
