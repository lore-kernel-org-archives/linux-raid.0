From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Full use of varying drive sizes?
Date: Wed, 23 Sep 2009 09:20:32 +0100
Message-ID: <4AB9DA50.5040007@anonymous.org.uk>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com> <73e903670909220452r2c4098c5w321f65c103b68a83@mail.gmail.com> 	<4AB8C9D9.6060406@anonymous.org.uk> <70ed7c3e0909220607y692e15a2s64aac9bd729422ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909220607y692e15a2s64aac9bd729422ef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/2009 14:07, Majed B. wrote:
> When I first put up a storage box, it was built out of 4x 500GB disks,
> later on, I expanded to 1TB disks.
> 
> What I did was partition the 1TB disks into 2x 500GB partitions, then
> create 2 RAID arrays: Each array out of partitions:
> md0: sda1, sdb1, sdc1, ...etc.
> md1: sda2, sdb2, sdc2, ...etc.
> 
> All of those below LVM.
> 
> This worked for a while, but when more 1TB disks started making way
> into the array, performance dropped because the disk had to read from
> 2 partitions on the same disk, and even worse: When a disk fail, both
> arrays were affected, and things only got nastier and worse with time.

Sorry, I don't quite see what you mean. Sure, if half your drives are 
500GB and half are 1TB, and you therefore have 2 arrays on the 1TB 
drives, with the arrays as PVs for LVM, and one filesystem over the lot, 
you're going to get twice as many read/write ops on the larger drives, 
but you'd get that just concatenating the drives with JBOD. I wasn't 
suggesting you let LVM stripe across the arrays, though - that would be 
performance suicide.

> I would not recommend that you create arrays of partitions that rely
> on each other.

Again I don't see what you mean by "rely on each other", they're just 
PVs to LVM.

Cheers,

John.

