From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: very large data-offset?
Date: Thu, 30 Nov 2017 10:45:09 +0000
Message-ID: <5A1FE135.8090000@youngman.org.uk>
References: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
Sender: linux-raid-owner@vger.kernel.org
To: Duane <duane@evenson.tk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/11/17 10:26, Duane wrote:
> Why is the data offset set so big? I created a 3x4TB RAID5 array and the
> data offset was 128MB. Chunk size was the default 512kB.
> 
> I cannot see why such a large offset is used. I would think the data
> offset need only be at most the chunk size plus the space (1 sector) for
> the superblock and bitmap.
> 
> When reshaping the array, I am prompted to use an external file, so I
> don't see that mdadm ever uses the space.
> 
Do you mean the manual tells you, or that mdadm refuses to run otherwise?

Certainly with a new array on larger disks, a backup file should be
totally unnecessary.

Run a reshape of some sort, and see if the offset changes :-)
> 
> I tried making some test arrays and got much smaller sizes. A 3x1GB
> RAID5 array with 64k chunks had a 1MB data offset.
> 
> 
> If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with
> setting the data offset to around 2MB?
> 
Dunno. How do you know the bitmap is "just one block"? I haven't dug in
to it so I don't know, but it makes sense to me that as the disks get
bigger, so does the bitmap.

What's the point of fighting the defaults, anyway? Just add
another/bigger disk if you need more space.

Cheers,
Wol

