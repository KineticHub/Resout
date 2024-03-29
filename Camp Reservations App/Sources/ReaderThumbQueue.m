//
//	ReaderThumbQueue.m
//	Reader v2.5.4
//
//	Created by Julius Oklamcak on 2011-09-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderThumbQueue.h"

@implementation ReaderThumbQueue

//#pragma mark Properties

//@synthesize ;

#pragma mark ReaderThumbQueue class methods

+ (ReaderThumbQueue *)sharedInstance
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	static dispatch_once_t predicate = 0;

	static ReaderThumbQueue *object = nil; // Object

	dispatch_once(&predicate, ^{ object = [self new]; });

	return object; // ReaderThumbQueue singleton
}

#pragma mark ReaderThumbQueue instance methods

- (id)init
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if ((self = [super init])) // Initialize
	{
		loadQueue = [NSOperationQueue new];

		[loadQueue setName:@"ReaderThumbLoadQueue"];

		[loadQueue setMaxConcurrentOperationCount:1];

		workQueue = [NSOperationQueue new];

		[workQueue setName:@"ReaderThumbWorkQueue"];

		[workQueue setMaxConcurrentOperationCount:1];
	}

	return self;
}

- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[loadQueue release], loadQueue = nil;

	[workQueue release], workQueue = nil;

	[super dealloc];
}

- (void)addLoadOperation:(NSOperation *)operation
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if ([operation isKindOfClass:[ReaderThumbOperation class]])
	{
		[loadQueue addOperation:operation]; // Add to load queue
	}
}

- (void)addWorkOperation:(NSOperation *)operation
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if ([operation isKindOfClass:[ReaderThumbOperation class]])
	{
		[workQueue addOperation:operation]; // Add to work queue
	}
}

- (void)cancelOperationsWithGUID:(NSString *)guid
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[loadQueue setSuspended:YES]; [workQueue setSuspended:YES];

	for (ReaderThumbOperation *operation in loadQueue.operations)
	{
		if ([operation isKindOfClass:[ReaderThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	for (ReaderThumbOperation *operation in workQueue.operations)
	{
		if ([operation isKindOfClass:[ReaderThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	[workQueue setSuspended:NO]; [loadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[loadQueue cancelAllOperations]; [workQueue cancelAllOperations];
}

@end

#pragma mark -

//
//	ReaderThumbOperation class implementation
//

@implementation ReaderThumbOperation

@synthesize guid = _guid;

#pragma mark ReaderThumbOperation instance methods

- (id)initWithGUID:(NSString *)guid
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	if ((self = [super init]))
	{
		_guid = [guid retain];
	}

	return self;
}

- (void)dealloc
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif

	[_guid release], _guid = nil;

	[super dealloc];
}

@end
