From: Michal Soltys <soltys@ziu.info>
Subject: Re: LVM and Raid5
Date: Thu, 17 Sep 2009 14:37:55 +0200
Message-ID: <4AB22DA3.2090901@ziu.info>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Linux Raid Study wrote:
> Hello:
> 
> Has someone experimented with LVM and Raid5 together (on say, 2.6.27)?
> Is there any performance drop if LVM/Raid5 are combined vs Raid5 alone?
> 
> Thanks for your inputs!

Few things to consider when setting up LVM on MD raid:

- readahead set on lvm device

It defaults to 256 on any LVM device, while MD will set it 
accordingly to the amount of disks present in the raid. 
If you do tests on a filesystem, you may see significant 
differences due to that. YMMV depending on the type of used 
benchmark(s).

- filesystem awareness of underlying raid

For example, xfs created on top of raid, will generally get 
the parameters right (stripe unit, stripe width), but if 
it's xfs on lvm on raid, then it won't - you will have 
to provide them manually.

- alignment between LVM chunks and MD chunks

Make sure that extent area used for actual logical volumes 
start at the boundary of stripe unit - you can adjust the 
LVM's metadata size during pvcreate (by default it's 192KiB, so 
with non-default stripe unit it may cause issues, although 
I vaguely recall posts that current LVM is MD aware during 
initialization). Of course LVM must itself start at the boundary 
for that to make any sense (and it doesn't have to be the case - 
for example if you use partitionable MD).

The best case is when LVM chunk is a multiple of stripe width, as 
in such case non-linear logical volumes will be always split 
at the stripe width boundary. But that requires 2^n data disks, 
which is not always the case.
