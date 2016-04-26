From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 09/13] md-cluster: always setup in-memory bitmap
Date: Tue, 26 Apr 2016 11:22:37 +0800
Message-ID: <571EDEFD.3090103@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
 <1461218294-4960-10-git-send-email-gqjiang@suse.com>
 <20160425174521.GB11993@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160425174521.GB11993@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/26/2016 01:45 AM, Shaohua Li wrote:
> On Thu, Apr 21, 2016 at 01:58:10PM +0800, Guoqing Jiang wrote:
>> The in-memory bitmap for raid is allocated on demand,
>> then for cluster scenario, it is possible that slave
>> node which received RESYNCING message doesn't have the
>> in-memory bitmap when master node is perform resyncing,
>> so we can't make bitmap is match up well among each
>> nodes.
>>
>> So for cluster scenario, we need always preserve the
>> bitmap, and ensure the page will not be freed. And a
>> no_hijack flag is introduced to both bitmap_checkpage
>> and bitmap_get_counter, which makes cluster raid returns
>> fail once allocate failed.
>>
>> And the next patch is relied on this change since it
>> keeps sync bitmap among each nodes during resyncing
>> stage.
>>
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   drivers/md/bitmap.c | 59 +++++++++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 46 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>> index 7df6b4f..00cf1c1 100644
>> --- a/drivers/md/bitmap.c
>> +++ b/drivers/md/bitmap.c
>> @@ -46,7 +46,7 @@ static inline char *bmname(struct bitmap *bitmap)
>>    * allocated while we're using it
>>    */
>>   static int bitmap_checkpage(struct bitmap_counts *bitmap,
>> -			    unsigned long page, int create)
>> +			    unsigned long page, int create, int no_hijack)
>>   __releases(bitmap->lock)
>>   __acquires(bitmap->lock)
>>   {
>> @@ -90,6 +90,9 @@ __acquires(bitmap->lock)
>>   
>>   	if (mappage == NULL) {
>>   		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
>> +		/* We don't support hijack for cluster raid */
>> +		if (no_hijack)
>> +			return -ENOMEM;
>>   		/* failed - set the hijacked flag so that we can use the
>>   		 * pointer as a counter */
>>   		if (!bitmap->bp[page].map)
>> @@ -1177,7 +1180,7 @@ static void bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
>>   
>>   static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
>>   					    sector_t offset, sector_t *blocks,
>> -					    int create);
>> +					    int create, int no_hijack);
>>   
>>   /*
>>    * bitmap daemon -- periodically wakes up to clean bits and flush pages
>> @@ -1257,7 +1260,7 @@ void bitmap_daemon_work(struct mddev *mddev)
>>   		}
>>   		bmc = bitmap_get_counter(counts,
>>   					 block,
>> -					 &blocks, 0);
>> +					 &blocks, 0, 0);
>>   
>>   		if (!bmc) {
>>   			j |= PAGE_COUNTER_MASK;
>> @@ -1307,7 +1310,7 @@ void bitmap_daemon_work(struct mddev *mddev)
>>   
>>   static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
>>   					    sector_t offset, sector_t *blocks,
>> -					    int create)
>> +					    int create, int no_hijack)
>>   __releases(bitmap->lock)
>>   __acquires(bitmap->lock)
>>   {
>> @@ -1321,7 +1324,7 @@ __acquires(bitmap->lock)
>>   	sector_t csize;
>>   	int err;
>>   
>> -	err = bitmap_checkpage(bitmap, page, create);
>> +	err = bitmap_checkpage(bitmap, page, create, 0);
>>   
>>   	if (bitmap->bp[page].hijacked ||
>>   	    bitmap->bp[page].map == NULL)
> bitmap_get_counter doesn't use the new no_hijack parameter. And you always pass
> 0 to this function. so looks this change isn't required.
>

The below part of this patch pass 1 to bitmap_checkpage, so it is needed.

+	/* For cluster raid, need to pre-allocate bitmap */
+	if (mddev_is_clustered(bitmap->mddev)) {
+		unsigned long page;
+		for (page = 0; page < pages; page++) {
+			ret = bitmap_checkpage(&bitmap->counts, page, 1, 1);

Thanks,
Guoqing
