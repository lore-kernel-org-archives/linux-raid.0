From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID Configuration For New Home Server
Date: Wed, 02 Jun 2010 16:31:27 +0100
Message-ID: <4C06794F.8030908@anonymous.org.uk>
References: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>	<e35643473b05cc946fc35c0df2e85fcd.squirrel@mail.monkii.net> <AANLkTilAzPKlOMecKpQLIEPOqAhFDglR5STq3_QP_caW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilAzPKlOMecKpQLIEPOqAhFDglR5STq3_QP_caW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/2010 14:00, Carlos Mennens wrote:
> On Wed, Jun 2, 2010 at 3:54 AM,  <tron@monkii.net> wrote:
>> There are about as many answers to this as there are people using your
>> setup so let's all agree that there's no "one way" of doing things.
> 
> Thanks for all the suggestions and you guys are right. There will no
> right or wrong answer here but I just want to make sure I am not doing
> anything that will hinder / limit performance in my system. At most my
> system will simply idle and do nothing more than store a few files for
> me so I think RAID5 is going to be my selection for my / file system.
> I have 4 identical drives and need to partition them all the same to
> avoid any inconsistencies across the RAID array. Since Grub doesn't
> support RAID5 for /boot, I will need to make a 4 disk RAID1 for /boot
> & do the same for Swap. Does this look reasonable to you guys?
> 
> Partitioning the 1st disk below:
> 
> /dev/sda1 100 MB - RAID (bootable)
> /dev/sda2     2 GB - RAID
> /dev/sda3 320 GB - RAID
> 
> Do that same partition schema above for all 4 drives and then create my RAID:
> 
> /
> mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sda3 /dev/sdb3
> /dev/sdc3 /dev/sdd3
> 
> /boot
> mdadm --create /dev/md1 --level=1 --raid-devices=4 /dev/sda1 /dev/sdb1
> /dev/sdc1 /dev/sdd1
> 
> Swap
> mdadm --create /dev/md2 --level=1 --raid-devices=4 /dev/sda2 /dev/sdb2
> /dev/sdc2 /dev/sdd2
> 
> Would you guys change anything in my partition or 'mdadm' command?

I'd use RAID-10,f2 for the swap, and I'd consider a larger than default 
chunk size for the RAID-5.

If I remember correctly, RAID-10 isn't resizeable at the moment, but for 
swap that doesn't matter in that if you add drives you can turn swap 
off, recreate the swap device with more drives in it, and turn swap on 
again.

I'd also try to avoid using several new drives all from the same batch 
from the same manufacturer, but if that's what I had to use I'd run 
badblocks in write mode on them all first to run them in a little and 
make sure all of them passed without any sectors being reallocated 
(check with smartctl). That may just be paranoia on my part but I did 
have a batch of drives with 2 duff ones in it not long ago. Anyway, if 
I'd done that, I'd create the arrays with --assume-clean because the 
drives would definitely be full of all zeroes.

Once built I'd add an internal write-intent bitmap with a much larger 
than default chunk size (16MB probably) to the big RAID-5 array.

Cheers,

John.
