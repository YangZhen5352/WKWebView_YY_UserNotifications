//
//  SiriKitController.m
//  WKWebView_YY
//
//  Created by 杨振 on 2016/11/21.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "SiriKitController.h"
#import <Speech/Speech.h>

@interface SiriKitController ()

@end

@implementation SiriKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRecognizer];
}

- (void)startRecognizer {
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized)
        {
            SFSpeechRecognizer *sf =[[SFSpeechRecognizer alloc] init];
            NSURL *mp3Path = [[NSBundle bundleForClass:[self class]] URLForResource:@"泡沫" withExtension:@"mp3"];
            SFSpeechURLRecognitionRequest *speechRequest = [[SFSpeechURLRecognitionRequest alloc]initWithURL:mp3Path];
            [sf recognitionTaskWithRequest:speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
                NSString * translatedString = [[[result bestTranscription] formattedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSLog(@"%@",translatedString);
            }];
        }
    }];
}

@end
