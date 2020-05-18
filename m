From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: =?UTF-8?Q?Re=3a_=5bPATCH_2/2=5d_restripe=3a_fix_ignoring_return_val?=
 =?UTF-8?B?dWUgb2Yg4oCYcmVhZOKAmQ==?=
Date: Mon, 18 May 2020 19:32:33 +0200
Message-ID: <607932ff-0e76-9eca-1fdb-ca26428d8717@cloud.ionos.com>
References: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
 <20200515134026.8084-3-guoqing.jiang@cloud.ionos.com>
 <4a888cbe-636b-b3a7-f669-8897753430d0@trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a888cbe-636b-b3a7-f669-8897753430d0@trained-monkey.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/18/20 7:22 PM, Jes Sorensen wrote:
> On 5/15/20 9:40 AM, Guoqing Jiang wrote:
>> Got below error when run "make everything".
>>
>> restripe.c: In function ‘test_stripes’:
>> restripe.c:870:4: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
>>      read(source[i], stripes[i], chunk_size);
>>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Fix it by set the return value of ‘read’ to diskP, which should be
>> harmless since diskP will be set again before it is used.
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> ---
>>   restripe.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/restripe.c b/restripe.c
>> index 31b07e8..21c90f5 100644
>> --- a/restripe.c
>> +++ b/restripe.c
>> @@ -867,7 +867,11 @@ int test_stripes(int *source, unsigned long long *offsets,
>>   
>>   		for (i = 0 ; i < raid_disks ; i++) {
>>   			lseek64(source[i], offsets[i]+start, 0);
>> -			read(source[i], stripes[i], chunk_size);
>> +			/*
>> +			 * To resolve "ignoring return value of ‘read’", it
>> +			 * should be harmless since diskP will be again later.
>> +			 */
>> +			diskP = read(source[i], stripes[i], chunk_size);
> It doesn't complain on Fedora 32, however checking the return value of
> lseek64 and read is a good thing.
>
> However what you have done is to just masking the return value and
> throwing it away, is not OK. Please do it properly.

Yes, it is used to suppress the warning. And set the return value to a 
new variable
could cause unused-but-set-variable, not sure if there is better way now.

Thanks,
Guoqing
