From: Daniel Brockhaus <joker@astonia.com>
Subject: Re: Soft-/Hardware RAID Performance
Date: Thu, 20 Feb 2003 11:55:39 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20030220112347.028ef5c0@195.90.31.33>
References: <5.1.0.14.0.20030219202741.027d3ec0@195.90.31.33>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.0.20030219202741.027d3ec0@195.90.31.33>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

I've received some helpful responses, and I'd like to share those, and the 
new test results. Let me know if I'm boring you to death. ;)

One suggestion to speed up the reads was to issue several reads in 
parallel. Silly me didn't think of that, I was completely focused on the 
writes, which are more important for my application. Anyway. Using parallel 
reads (from four processes), read performance scales almost with the number 
of disks in the array. This goes for both, hardware and software RAID, with 
software RAID being about 15% faster.

Write performance on the other hand does not change at all when using 
multiple processes - for obvious reasons: The kernel queues, sorts and 
merges write requests anyway, so the number of processes doing the writes 
does not matter. But I've noticed something peculiar: If I change my 
benchmark to write 4K blocks at 4K boundaries, write performance increases 
to almost 300%. This is quite logical, since the kernel can write a 'page 
aligned' block directly to the disk, without having to read the remaining 
parts of the page from disk first. The strange thing is that the expected 
performance gain from using RAID0 does show when writing aligned 4K blocks, 
but not when writing unaligned blocks. Non-aligned writes also tend to 
block much more often than aligned writes do. It seems the kernel doesn't 
handle unaligned writes very well. I can't be sure without having read the 
kernel sources (which I don't intend to do, they give me a headache), but I 
think the kernel serializes the reads needed to do the writes, thus killing 
any performance gain from using RAID arrays.

Concerning the question how to use one hot spare for two arrays, Neil 
recommendet using mdadm. I'll take a look at it today, thanks :)

Regards,
Daniel Brockhaus

At 20:56 19.02.03 +0100, you wrote:
>I need to build a server for an application that does lots of small writes 
>and some small reads. So far I've build the hardware side of the server, 
>using an Adaptec 2100S RAID controller and five Fujitsu MAM3184MP. My 
>original intention was to build a RAID 10 array (RAID0 on two mirror sets 
>of two disks each with one spare). But performance was very poor with this 
>setup. I used a custom benchmark which reads and writes 4K blocks in 
>random locations in a 2GB file (this is very close to the actual application):
>
>Test results for :
>
>Cheap IDE drive: 50 writes/s, 105 reads/s.
>MAM3184MP: 195 writes/s, 425 reads/s.
>
>This is as expected. But:
>
>Hardware RAID10 array: 115 writes/s, 405 reads/s.
>
>Which is way slower than a single drive. Now the testing began:
>
>Hardware RAID1: 145 writes/s, 420 reads/s.
>Software RAID1: 180 writes/s, 450 reads/s.
>Software RAID10: 190 writes/s, 475 reads/s.
>
>Since write performance is more important than read performance, a single 
>drive is still faster than any configuration using two or four drives I've 
>tried. So the question is: Are there any tunable parameters which might 
>increase performance? In theory, read performance on a two-disk RAID1 
>array should be almost twice as high as on a single disk while write 
>performance should (almost) stay the same, and a two-disk RAID0 array 
>should double both, read and write performance. So the whole RAID10 array 
>should be able to manage 350 writes/s and 1600 reads/s. What am I missing?
>
>Performance issues aside. If I go for the software RAID10: How can I 
>configure the system to use the fifth drive as hot spare for both RAID1 
>arrays? Is it save to add the same drive to both arrays (haven't tried it 
>yet)? And would you say that software RAID is stable enough to use in a 
>production system?

