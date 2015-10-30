From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Fri, 30 Oct 2015 14:12:00 -0400
Message-ID: <5633B2F0.9010902@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
 <562D5F91.5040300@turmel.org> <5630F862.5040308@tantosonline.com>
 <5630FB05.5070902@turmel.org> <56325086.4060104@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56325086.4060104@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Tantos <andras@tantosonline.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/29/2015 12:59 PM, Andras Tantos wrote:
> Phil,
> 
> On 10/28/2015 9:42 AM, Phil Turmel wrote:
>> If you stop the array cleanly and then manually re-assemble with
>> --update=metadata, you might get around it. (Specify all of the
>> devices explicitly to ensure you don't get burned by v0.90's problems
>> with last partitions.) You definitely don't want to stay on v0.90, but
>> you may need to for now to get out of trouble. Phil 
> 
> It seems that my mdadm doesn't have an --update=metadata option, which
> if I understand it right means I have to re-create the array with the
> no-bitmap option. How dangerous is that? Is it possible that things get
> overwritten during the re-create process in the data portion of the array?

Just clone and compile a local copy of the latest mdadm, then run it as
./mdadm for the --update operation.

git clone git://github.com/neilbrown/mdadm

> I've read that GRUB (which is my bootloader) didn't support v1.0
> superblocks for a while. It seems that 0.99 version of GRUB (which is
> what I have) has it, but how to make certain? I don't want to render my
> system un-bootable...

Old grub doesn't understand MD at all, which is why you needed a mirror
that has the content starting at the beginning of the partition.  To
grub, it doesn't look like a mirror.  This is true for v1.0 as well.

> Can you expand a little bit on the problems of v0.90 superblocks and why
> upgrading is advantageous? What I've read about the differences (lifted
> limit of number of devices/array and 2TB per device limit) don't really
> apply to my case.

v0.90 will screw up if you have it on the last partition of a device,
and that partition runs very close to the end of the device.  v0.90
doesn't include size info in the metadata itself, so it is ambiguous in
that case whether the superblock belongs to the device as a whole or the
partition.  That'll really scramble an array.

Just say no to v0.90.

Phil
