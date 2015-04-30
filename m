From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 03/10] Create n bitmaps for clustered mode
Date: Thu, 30 Apr 2015 10:44:23 +0800
Message-ID: <55419707.9050302@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-4-git-send-email-gqjiang@suse.com> <20150429114115.2265643f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429114115.2265643f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:34 +0800 gqjiang@suse.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> For a clustered MD, create bitmaps equal to number of nodes so
>> each node has an independent bitmap.
>>
>> Only the first bitmap is has the bits set so that the first node
>> that assembles the device also performs the sync.
>>
>> The bitmaps are aligned to 4k boundaries.
>>
>> On-disk format:
>>
>> 0                    4k                     8k                    12k
>> -------------------------------------------------------------------
>> | idle                | md super            | bm super [0] + bits |
>> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
>> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
>> | bm bits [3, contd]  |                     |                     |
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>  Create.c   |  3 ++-
>>  bitmap.h   |  7 +++++--
>>  mdadm.8.in |  7 ++++++-
>>  mdadm.c    | 17 ++++++++++++++++-
>>  super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++------------------
>>  5 files changed, 70 insertions(+), 23 deletions(-)
>>
>> diff --git a/Create.c b/Create.c
>> index cd5485b..9663dc4 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -752,7 +752,8 @@ int Create(struct supertype *st, char *mddev,
>>  #endif
>>  	}
>>  
>> -	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")==0) {
>> +	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")==0
>> +			|| strcmp(s->bitmap_file, "clustered")==0)) {
>>  		if ((vers%100) < 2) {
>>  			pr_err("internal bitmaps not supported by this kernel.\n");
>>  			goto abort_locked;
>> diff --git a/bitmap.h b/bitmap.h
>> index c8725a3..adbf0b4 100644
>> --- a/bitmap.h
>> +++ b/bitmap.h
>> @@ -154,8 +154,11 @@ typedef struct bitmap_super_s {
>>  	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
>>  	__u32 daemon_sleep; /* 56  seconds between disk flushes */
>>  	__u32 write_behind; /* 60  number of outstanding write-behind writes */
>> -
>> -	__u8  pad[256 - 64]; /* set to zero */
>> +	__u32 sectors_reserved; /* 64 number of 512-byte sectors that are
>> +				 * reserved for the bitmap. */
>> +	__u32 nodes;        /* 68 the maximum number of nodes in cluster. */
>> +	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
>> +	__u8  pad[256 - 136]; /* set to zero */
>>  } bitmap_super_t;
>>     
>
> I missed this the first time, but these fields that you have added need to be
> added to sb_le_to_cpu().
>
>   
I guess only nodes need to be added as follows:
    sb->nodes = __le32_to_cpu(sb->nodes);

Does the cluster_name need to be addressed too? Like.
    for (i = 0; i < 64; i++)
       sb->cluster_name[i] = (unsigned
char)__le16_to_cpu(sb->cluster_name[i]);

Thanks,
Guoqing
> NeilBrown
>   

