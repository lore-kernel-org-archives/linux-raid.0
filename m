From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: Full use of varying drive sizes?
Date: Wed, 23 Sep 2009 13:15:05 +0300
Message-ID: <20090923101505.GA11165@hamsu.tarvainen.info>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com> <73e903670909220452r2c4098c5w321f65c103b68a83@mail.gmail.com> <4AB8C9D9.6060406@anonymous.org.uk> <70ed7c3e0909220607y692e15a2s64aac9bd729422ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909220607y692e15a2s64aac9bd729422ef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 22, 2009 at 04:07:53PM +0300, Majed B. (majedb@gmail.com) wrote:

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

I'm not 100% sure I understand what you did, but for the record,
I've got a box with four 1TB disks arranged roughly like this:

md0: sda1, sdb1, sdc1, sde1
md1: sda2, sdb2, sdc2, sde2
md2: sda3, sdb3, sdc3, sde3
md3: sda4, sdb4, sdc4, sde4

and each md a pv under lvm, and it's been running problem-free
for over a year now. (No claims about performance, haven't
made any usable measurements, but it's fast enough for what
it does.)

When it was new I had strange problems of one disk dropping out of the
arrays every few days. The reason was traced to faulty SATA controller
(replacing it fixed the problem), but the process revealed an extra
advantage in the partitioning scheme: the lost disk could be added
back after reboot and array rebuilt, but the fault had appeared
in only one md at a time, so recovery was four times faster
than if the disks had had only one partition.

-- 
Tapani Tarvainen
