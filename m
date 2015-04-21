From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 1/6] md-cluster: correct the num for comparison
Date: Tue, 21 Apr 2015 11:31:14 -0500
Message-ID: <55367B52.6000905@suse.de>
References: <20150414154232.GA4079@shrek.lan> <20150420114804.6e570389@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150420114804.6e570389@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 04/19/2015 08:48 PM, NeilBrown wrote:
> On Tue, 14 Apr 2015 10:42:32 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>> Author: Guoqing Jiang <gqjiang@suse.com>
>>
>> Since the node num of md-cluster is from zero, and
>> cinfo->slot_number represents the slot num of dlm,
>> no need to check for equality.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index 96679b2..6bdc45e 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -612,7 +612,7 @@ static int join(struct mddev *mddev, int nodes)
>>   	if (ret)
>>   		goto err;
>>   	wait_for_completion(&cinfo->completion);
>> -	if (nodes <= cinfo->slot_number) {
>> +	if (nodes < cinfo->slot_number) {
>>   		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)", cinfo->slot_number - 1,
>>   			nodes);
>>   		ret = -ERANGE;
>
> I'll apply this, but it would be nice to fix the error message too.
> If 'nodes' is 3 and 'slot_number' is 4, then the message would be
>     md-cluster: Slot allotted(3) greater than available slots(3)
> which looks weird.
> (it should be "is greater", and there should be a "." at the end of the
> sentence).
>


Yes, I have corrected this and re-sent the patch.

Thanks,


-- 
Goldwyn
