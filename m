From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Soft-/Hardware RAID Performance
Date: Fri, 21 Feb 2003 11:08:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15957.28133.443983.560660@notabene.cse.unsw.edu.au>
References: <5.1.0.14.0.20030219202741.027d3ec0@195.90.31.33>
	<5.1.0.14.0.20030220112347.028ef5c0@195.90.31.33>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Brockhaus on Thursday February 20
To: Daniel Brockhaus <joker@astonia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 20, joker@astonia.com wrote:
> Hi again,
> 
> I've received some helpful responses, and I'd like to share those, and the 
> new test results. Let me know if I'm boring you to death. ;)
> 
> One suggestion to speed up the reads was to issue several reads in 
> parallel. Silly me didn't think of that, I was completely focused on the 
> writes, which are more important for my application. Anyway. Using parallel 
> reads (from four processes), read performance scales almost with the number 
> of disks in the array. This goes for both, hardware and software RAID, with 
> software RAID being about 15% faster.
> 
> Write performance on the other hand does not change at all when using 
> multiple processes - for obvious reasons: The kernel queues, sorts and 
> merges write requests anyway, so the number of processes doing the writes 
> does not matter. But I've noticed something peculiar: If I change my 
> benchmark to write 4K blocks at 4K boundaries, write performance increases 
> to almost 300%. This is quite logical, since the kernel can write a 'page 
> aligned' block directly to the disk, without having to read the remaining 
> parts of the page from disk first. The strange thing is that the expected 
> performance gain from using RAID0 does show when writing aligned 4K blocks, 
> but not when writing unaligned blocks. Non-aligned writes also tend to 
> block much more often than aligned writes do. It seems the kernel doesn't 
> handle unaligned writes very well. I can't be sure without having read the 
> kernel sources (which I don't intend to do, they give me a headache), but I 
> think the kernel serializes the reads needed to do the writes, thus killing 
> any performance gain from using RAID arrays.

When you do unaligned writes to a block device, it pre-reads the parts
of each page that you don't write.  This causes your loss of
perfomance.

I *think* (i.e. vague memory from reading code suggests) that if you
open with O_DIRECT and make sure all your accesses are 512 byte
aligned and a multiple of 512 bytes in size, it should avoid the
pre-reading and should give you full performance.

NeilBrown
