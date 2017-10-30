From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [mdadm PATCH] mdadm: make create clustered raid10 possible
Date: Mon, 30 Oct 2017 14:54:21 +0800
Message-ID: <59F6CC9D.8020206@suse.com>
References: <20171024073124.7751-1-gqjiang@suse.com>
 <20171030055717.x5rgvkymaygitzfn@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171030055717.x5rgvkymaygitzfn@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: jsorensen@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/30/2017 01:57 PM, Shaohua Li wrote:
> On Tue, Oct 24, 2017 at 03:31:24PM +0800, Guoqing Jiang wrote:
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
>>   				rv = 1;
>>   				break;
> Since kernel only supports near layout for raid10 cluster, probably check the
> layout in mdadm too?

The changes in raid10_run has ensured only near layout is possible for 
clustered raid10.
Anyway, I will add the check either.

Thanks,
Guoqing
