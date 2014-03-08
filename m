From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sat, 08 Mar 2014 12:42:33 +0100
Message-ID: <531B0229.7030800@grumpydevil.homelinux.org>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com> <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico Foschini <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08-03-14 12:16, Federico Foschini wrote:
> The old system had only sda and sdb in raid1. Now I've made a linear
> array with sda and sdb and created a new raid1 array with sdd.
>
>>> Is there something wrong with my setup?
>> Do you have any reason to think so?
> Yes, because yesterday I've update the kernel and grub complained
> about "raid array -1 not found".
> Also why sda and sdb have both a partition defined as "linux raid" but
> sdd doesn't? Where is the correct way to create an array? If I
> remember correctly these are the steps I did:
>
> 0) The system was /dev/sda1 /dev/sdb1 in raid1 (dev/md0) with a LVM
> partition on top of the raid
> 1) I created a new degradeted raid 1 /dev/md1 array with /dev/sdd
> (without defining any partition)
> 2) I've mounted /dev/md1 and formatted as ext4. Then I copied
> everything from /dev/md0
> 3) I destroyed the old /dev/md0 and than recreated a new /dev/md0 as a
> linear array
> 4) I've added /dev/md0 on /dev/md1 and the drivers start syncying
>
> Than I've update the kernel and grub complained about "raid array -1".
> When I restarted the system a Grub error 17 was showed.
> So I booted from an usb key and restored grub (I think I installed it
> wrongly on /dev/sda instead of the correct drive /dev/sdc) and the
> system booted correctly.
>
one more question before i give my best guess

Do you use a initrd to load modules during boot, or do does your kernel 
contain all drivers in itself?

Cheers


Rudy
