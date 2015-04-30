From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 04/10] Show all bitmaps while examining bitmap
Date: Thu, 30 Apr 2015 11:17:28 +0800
Message-ID: <55419EC8.4030407@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-5-git-send-email-gqjiang@suse.com> <20150429114140.07b20a08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429114140.07b20a08@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:35 +0800 gqjiang@suse.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> This adds capability of exmining bitmaps corresponding to all
>> nodes/slots on the device.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>  bitmap.c | 35 ++++++++++++++++++++++++++---------
>>  1 file changed, 26 insertions(+), 9 deletions(-)
>>
>> diff --git a/bitmap.c b/bitmap.c
>> index b1d54a6..ab83f4e 100644
>> --- a/bitmap.c
>> +++ b/bitmap.c
>> @@ -258,7 +258,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
>>  	int rv = 1;
>>  	char buf[64];
>>  	int swap;
>> -	int fd;
>> +	int fd, i;
>>  	__u32 uuid32[4];
>>  
>>  	fd = bitmap_file_open(filename, &st);
>> @@ -315,9 +315,6 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
>>  		       uuid32[2],
>>  		       uuid32[3]);
>>  
>> -	printf("          Events : %llu\n", (unsigned long long)sb->events);
>> -	printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cleared);
>> -	printf("           State : %s\n", bitmap_state(sb->state));
>>     
>
> Can we please leave this where it is in the case where there is only one node?
> Only move it down if there are multiple nodes to report on.
>
>   
Yes, it could be possible. Just to make sure understand you correctly,
what about the below?

if (sb->nodes == 0) {
    /* code for more than one node */
} else {
   /* original code */
}

Thanks,
Guoqing



