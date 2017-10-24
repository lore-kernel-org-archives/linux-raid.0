From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [mdadm PATCH] mdadm: make create clustered raid10 possible
Date: Tue, 24 Oct 2017 16:09:35 -0400
Message-ID: <b9068158-556c-7f6c-0a90-afef01e95b89@fb.com>
References: <20171024073124.7751-1-gqjiang@suse.com>
 <87efpse2h1.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efpse2h1.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/24/2017 04:05 PM, NeilBrown wrote:
> On Tue, Oct 24 2017, Guoqing Jiang wrote:
> 
>> This change to make we can create a clustered
>> raid10 array as well.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   mdadm.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mdadm.c b/mdadm.c
>> index 7cdcdba7c652..60d80e0103f4 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1542,8 +1542,9 @@ int main(int argc, char *argv[])
>>   				break;
>>   			}
>>   
>> -			if (s.level != 1) {
>> -				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
>> +			if (s.level != 1 && s.level != 10) {
>> +				pr_err("--bitmap=clustered is currently "
>> +				       "supported with raid1/10 only\n");
> 
> 
> Please don't wrap strings.  It makes it hard to search for them.
> Long line might be bad, but wrapped strings are worse.

Personally I actually prefer the wrapped strings over the long lines, 
but given the kernel consensus is not to wrap, I apply that rule to 
mdadm as well.

Cheers,
Jes


