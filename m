From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 06 Feb 2008 14:03:27 -0500
Message-ID: <47AA047F.9060507@tmr.com>
References: <200802051142.19625.admin@domeny.pl> <18344.49968.584648.904844@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18344.49968.584648.904844@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Marcin Krol <admin@domeny.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday February 5, admin@domeny.pl wrote:
>   
>> % mdadm --zero-superblock /dev/sdb1
>> mdadm: Couldn't open /dev/sdb1 for write - not zeroing
>>     
>
> That's weird.
> Why can't it open it?
>
>   
I suspect that (a) he's not root and has read-only access to the device 
(I have group read for certain groups, too). And since he had the arrays 
on raw devices, shouldn't he zero the superblocks using the whole device 
as well? Depending on what type of superblock it might not be found 
otherwise.

It sure can't hurt to zero all the superblocks of the whole devices and 
then check the partitions to see if they are present, then create the 
array again with --force and be really sure the superblock is present 
and sane.

> Maybe you aren't running as root (The '%' prompt is suspicious).
> Maybe the kernel has  been told to forget about the partitions of
> /dev/sdb.
> mdadm will sometimes tell it to do that, but only if you try to
> assemble arrays out of whole components.
>
> If that is the problem, then
>    blockdev --rereadpt /dev/sdb
>
> will fix it.
>
> NeilBrown

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


