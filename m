From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH V2] md-cluster: make md-cluster also can work when
 compiled into kernel
Date: Sun, 4 Sep 2016 21:46:48 -0400
Message-ID: <57CCCE88.4010507@suse.com>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
 <1472911410-15469-1-git-send-email-gqjiang@suse.com>
 <87zinn9rkc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zinn9rkc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids



On 09/04/2016 07:24 PM, NeilBrown wrote:
> On Sun, Sep 04 2016, Guoqing Jiang wrote:
>
>> The md-cluster is compiled as module by default,
>> if it is compiled by built-in way, then we can't
>> make md-cluster works.
>>
>> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
>> [64782.630528] md-cluster module not found.
>> [64782.630530] md127: Could not setup cluster service (-2)
>>
>> Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster functions")
>> Cc: stable@vger.kernel.org # v4.1+
> The above results in you sending email to
>     stable@vger.kernel.org#v4.1+
> which is not a valid address.
>
> The correct form for comments in email address is to use parentheses.
> e.g.
>     Cc: stable@vger.kernel.org (v4.1+)

Thanks for correct it!

>> Cc: NeilBrown <neilb@suse.com>
>> Reported-by: Marc Smith <marc.smith@mcc.edu>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>> Changes:
>> 1. call try_module_get if md_cluster_ops is already set,
>> otherwise try_module_get/module_put are unbalanced.
>>
>>   drivers/md/md.c | 14 +++++---------
>>   1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 67642ba..6ac5abe 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -7610,16 +7610,12 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>>   
>>   int md_setup_cluster(struct mddev *mddev, int nodes)
>>   {
>> -	int err;
>> -
>> -	err = request_module("md-cluster");
>> -	if (err) {
>> -		pr_err("md-cluster module not found.\n");
>> -		return -ENOENT;
>> -	}
>> -
>> +	if (!md_cluster_ops)
>> +		request_module("md-cluster");
>>   	spin_lock(&pers_lock);
>> -	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
>> +	/* ensure module won't be unloaded */
>> +	if (!try_module_get(md_cluster_mod)) {
> Why did you drop the "!md_cluster_ops" test?
>
> What happens if the md-cluster module cannot be loaded?
> md_cluster_ops will be NULL and md_cluster_mod will be NULL.
> try_module_get(NULL) succeeds, so with this patch md_setup_cluster()
> will succeed if the module is needed but fails to load.

Yes, I just find try_module_get(NULL) could return true, it seems not
correct for the return value, maybe it need to be changed to:

             return module ? ret : false;

Anyway, I will send v3 with add "!md_cluster_ops" test back.

Thanks,
Guoqing

