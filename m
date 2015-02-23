From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 02/24] Add number of nodes to bitmap structure for clustering
Date: Mon, 23 Feb 2015 12:13:32 -0600
Message-ID: <54EB6DCC.7020406@suse.de>
References: <20141218161523.GA29576@shrek.lan> <20150223123848.01416b69@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150223123848.01416b69@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

On 02/22/2015 07:38 PM, NeilBrown wrote:
> On Thu, 18 Dec 2014 10:15:23 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   drivers/md/bitmap.h | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
>> index 30210b9..6872945 100644
>> --- a/drivers/md/bitmap.h
>> +++ b/drivers/md/bitmap.h
>> @@ -128,10 +128,11 @@ typedef struct bitmap_super_s {
>>   	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
>>   	__le32 daemon_sleep; /* 56  seconds between disk flushes */
>>   	__le32 write_behind; /* 60  number of outstanding write-behind writes */
>> -	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
>> +	__le32 nodes;        /* 64 the maximum number of nodes in cluster. */
>> +	__le32 sectors_reserved; /* 68 number of 512-byte sectors that are
>>   				  * reserved for the bitmap. */
>>
>> -	__u8  pad[256 - 68]; /* set to zero */
>> +	__u8  pad[256 - 72]; /* set to zero */
>>   } bitmap_super_t;
>>
>>   /* notes:
>
> Hi Goldwyn,
>   I was reviewing you latest series to make sure it wouldn't affect the
>   non-clustered use case at all, and I found this.  I really should have
>   noticed it earlier....
>
>   You are changing the location of 'sectors_reserved' in the bitmap superblock.
>   That obviously cannot be allowed - new fields must always be added to the
>   end.

Oops. Sorry.

>
>   Can you update the series in git to fix that please?  Then I will pull it in
>   for -next.

I have done this and re-tested. However, I also rebased against 
upstream. There were some conflicts with respect to md_personality. I 
have re-done those patches, but it would be worth a second look. The one 
which may need special review attention is "bitmap_create returns bitmap 
pointer"


Regards,

-- 
Goldwyn
