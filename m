From: Carlos Mennens <carloswill@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Sat, 13 Mar 2010 18:18:48 -0500
Message-ID: <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
References: <4B9C11FB.7040604@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9C11FB.7040604@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am glad I asked! Thanks for all the info. Now my question next is if
I am creating a 3 disk raid with a 1 disk spare, do I need to use any
special 'mdadm' parameters besides what u see below for /boot (Grub)?

# mdadm --create /dev/md0 --level=1 --raid-devices=3 /dev/sda1
/dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1

Anything else I should add to the above command for my /boot partition?

On 3/13/10, Joachim Otahal <Jou@gmx.net> wrote:
> On Sun, Mar 14, 2010 at 12:06 AM, Carlos Mennens<carloswill@gmail.com>
> wrote:
>>  I was told by my distributions Wiki page that Grub doesn't support
>>  RAID 5 or RAID 6 so I would need to create a volume with three disks
>>  and set the level to RAID 1:
>>
>>  # mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sda1
>>  /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1
>>
>>  Is this possible to mirror three identical drive partitions? I was
>>  talking to some co-workers and was told that I could only pair two
>>  drives on RAID 1.
>>
>>  Can anyone please help me understand this?
>
> /boot must be RAID1 (or a normal partition), everything else can be
> RAIDwhatever. Grub has no problems reading /boot from a mirrors.
>
> It is possible to make RAID1 to use more than two drives and keep the all
> active. In your case it is a matter of "believe" whether a spare is better
> or actually using all four actively in your raid, I prefer the latter.
> I have heavily tested more than two only with files via loopback yet, two
> drive, three drives, four drives and more. It does work, the testfile
> generated out of urandom kept the correct hash value throughout all my sick
> testings.
> The quick test with three SATA drives worked too, but it was just for the
> fun to see whether grub pukes or works (works if you don't forget the grub
> setup for drive 2, 3 etc).
> My plan is: Use RAID1 with 4 drives (quad-mirroring) for /boot or / and
> raid10 or raid5 for the data upon my next linux server upgrade.
>
> Joachim Otahal
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Sent from my mobile device
