From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 11:07:31 +0100
Message-ID: <CAOS+5GF22YN8OagwQiXy4gxn94eTLt-X31VhWoU47r_kgLLYnQ@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
	<CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
	<alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
	<CAOS+5GEZN5d41tGxN+PP6S3ynSWnrXaNK+27rxJyXa-zw1KFaw@mail.gmail.com>
	<alpine.DEB.2.02.1505241142350.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505241142350.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But reading this.....

https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-1_Superblock_Format

it makes a sound argument for the metadata superblock being at the
beginning of the drive.......in a nutshell the kernel can 'construct'
the md device easier if the metadata is at the beginning....as well as
data resilience issues in the case of a crash.



On 24 May 2015 at 10:46, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sun, 24 May 2015, Another Sillyname wrote:
>
>> I suspect you're correct in that I'll end up with the boot partitions
>> being in RAID1 and the data in RAID6, however I am seriously
>> considering having the boot in RAID6 as well...if I can integrate the
>> mdadm.conf into the initramfs properly I can't see a reason not to do
>> this?
>
>
> The initramfs is usually located on the boot partition. A raid1 partition
> with a filesystem can be read by the bootloader even if the bootloader
> doesn't understand to start the raid first. This is not possible with raid6.
>
> So /boot is usually raid1.
>
>> Had a look at the metadata=0.9 option but reading the info on mdadm
>> metadata I think I'd prefer to have the metadata at the start of the
>> drive, also it looks like metadata=1.2 has extra functionality that I
>> may want to use later.
>
>
> Look at v1.0 superblock, it has the same functionality but stores the
> superblock at the end.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
