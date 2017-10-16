From: Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH] md/bitmap: clear BITMAP_WRITE_ERROR bit after reading it
 from sb
Date: Mon, 16 Oct 2017 11:22:02 +0800
Message-ID: <0fc40746-61f7-ba5e-90f2-a7dd98e13eef@huawei.com>
References: <1507890991-27425-1-git-send-email-houtao1@huawei.com>
 <20171013192127.5a4oznnkljfpv7ca@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171013192127.5a4oznnkljfpv7ca@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Hi,

On 2017/10/14 3:21, Shaohua Li wrote:
> On Fri, Oct 13, 2017 at 06:36:31PM +0800, Hou Tao wrote:
>> For a RAID1 device using a file-based bitmap, if a bitmap write error
>> occurs and the later writes succeed, it's possible both BITMAP_STALE
>> and BITMAP_WRITE_ERROR bit will be written to the bitmap super block,
>> and the BITMAP_WRITE_ERROR bit in sb->flags will make bitmap_create()
>> to fail.
> 
> Why don't clear the bit in the 'latter succeeded write'?

It will work too. Cleaning after read can ensure that after upgrading the
kernel we can activate the RAID1 successfully event if the write error
bit had been written to the bitmap.

>> So clear it to protect against the write failure-success case.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  drivers/md/bitmap.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>> index d212163..97c423a 100644
>> --- a/drivers/md/bitmap.c
>> +++ b/drivers/md/bitmap.c
>> @@ -688,8 +688,13 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>>  		}
>>  	}
>>  
>> -	/* assign fields using values from superblock */
>> -	bitmap->flags |= le32_to_cpu(sb->state);
>> +	/*
>> +	 * assign fields using values from superblock
>> +	 * clear BITMAP_WRITE_ERROR bit to protect against the case that
>> +	 * a bitmap write error had occurred and the later writes had
>> +	 * succeeded.
>> +	 */
>> +	bitmap->flags |= (le32_to_cpu(sb->state) & ~BIT(BITMAP_WRITE_ERROR));
>>  	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
>>  		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
>>  	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
>> -- 
>> 2.5.0
>>
> 
> .
> 

