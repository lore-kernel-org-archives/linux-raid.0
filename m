From: "Bradley D. Thornton" <website.is@www.NorthTech.US>
Subject: Re: Help with /etc/raidtab
Date: Tue, 8 Jul 2003 15:21:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <befg8h$sid$1@main.gmane.org>
References: <befehe$k5a$1@main.gmane.org>
Reply-To: "Bradley D. Thornton" <gmane@tallship.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I realize that the example below is ugly, sorry for that :(

Basically what I'm asking is, can't I just specify /dev/sdX in raidtab or do
I actually have to specify each and evry single partition on the disk for
the array to work - i.e., /dev/sdX#   ????

Please see below if you can deal with the lousy formatting.


"Bradley D. Thornton" <website.is@www.NorthTech.US> wrote in message
news:befehe$k5a$1@main.gmane.org...
> I've been looking around for example /etc/raidtabs and only seem to find
> ones that look like this:
>
> raiddev /dev/md0
>         raid-level      1
>         nr-raid-disks   2
>         nr-spare-disks  0
>         chunk-size     4
>         persistent-superblock 1
>         device          /dev/sda1
>         raid-disk       0
>         device          /dev/sdb1
>         raid-disk       1
> My question is, considering that I have multiple partitions that I want to
> array and I also want to boot from my RAID 1 array, can I just do this?
>         device          /dev/sda
>         raid-disk       0
>         device          /dev/sdb
>         raid-disk       1
> or do I need to do this?
>         device          /dev/sda1
>         raid-disk       0        device          /dev/sda3
raid-disk
> 0        device          /dev/sda5        raid-disk       0        device
> /dev/sda6        raid-disk       0        device          /dev/sdb1
>         raid-disk       1        device          /dev/sdb3
raid-disk
> 1        device          /dev/sdb5        raid-disk       1        device
> /dev/sdb6        raid-disk       1Any assistance would be greatly
> appreciated.
> ---Outgoing mail is certified Virus Free.Checked by AVG anti-virus system
> (http://www.grisoft.com).Version: 6.0.449 / Virus Database: 251 - Release
> Date: 01/27/03
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.449 / Virus Database: 251 - Release Date: 01/27/03



