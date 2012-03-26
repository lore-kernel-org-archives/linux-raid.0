From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] Avoid OOPS when reshaping raid1 to raid0
Date: Mon, 26 Mar 2012 10:29:43 +0200
Message-ID: <4F7028F7.5080401@redhat.com>
References: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com> <1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com> <20120326092905.27147102@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120326092905.27147102@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/26/12 00:29, NeilBrown wrote:
> On Thu, 22 Mar 2012 17:15:53 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> raid1 arrays do not have the notion of chunk size. Set the existing
>> chunk size of the new raid0 to the same as the proposed new chunk size
>> to avoid a divide by zero OOPS when aligning the size of the new array
>> to that of the chunk size.
> 
> This oops happens in create_strip_zones at
> 
> 		sector_div(sectors, mddev->chunk_sectors);
> 
> correct?

Correct

>>  	mddev->new_chunk_sectors = 128; /* by default set chunk size to 64k */
>> +	mddev->chunk_sectors = 128;	/*
>> +					 * a raid1 one doesn't have the
>> +					 * notion of chunk size, so set
>> +					 * existing chunk_sector to match the
>> +					 * new size to avoid divide by zero
>> +					 * when aligning the size of the new
>> +					 * raid0 to the existing chunk size.
>> +					 */
> 
> But what if the RAID1 is not a multiple of 64K ?  Then you will lose
> data.

Good point - I wasn't sure what the actual sizes would be in practice.

> We probably want the same thing we have in RAID5:
> 
> 
> 
> 	chunksect = 64*2; /* 64K by default */
> 
> 	/* The array must be an exact multiple of chunksize */
> 	while (chunksect && (mddev->array_sectors & (chunksect-1)))
> 		chunksect >>= 1;
> 
> 	if ((chunksect<<9) < STRIPE_SIZE)
> 		/* array size does not allow a suitable chunk size */
> 		return ERR_PTR(-EINVAL);
> 
> 
> ??
> 
> Do you want to make a patch, or shall I?

I have brewed up a patch based on this. I used PAGE_SIZE instead of
STRIPE_SIZE for the limit since we don't have stripes in raid0. I'll
post it in a minute.

Cheers,
Jes
