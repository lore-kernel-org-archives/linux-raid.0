From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 11:42:25 +0100
Message-ID: <CAOS+5GEzADXNoGXAWRsdXrB9e3DLKsKhxDU2W9kR6uevSsHQPA@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
	<CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
	<alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
	<CAOS+5GEZN5d41tGxN+PP6S3ynSWnrXaNK+27rxJyXa-zw1KFaw@mail.gmail.com>
	<alpine.DEB.2.02.1505241142350.9487@uplift.swm.pp.se>
	<CAOS+5GF22YN8OagwQiXy4gxn94eTLt-X31VhWoU47r_kgLLYnQ@mail.gmail.com>
	<alpine.DEB.2.02.1505241233540.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505241233540.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That's the whole point of trying this test......

As I have a working booting machine with currently 8 drives.......all
partitioned as above.

I have just created RAID5 mdadm setups on drives [d-h] on partitions
[2-5], once they've synced I'm going to see if I can install Live USB
Fedora to them and then boot from there.  If it doesn't work I've just
lost a bit of time.



On 24 May 2015 at 11:35, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sun, 24 May 2015, Another Sillyname wrote:
>
>> But reading this.....
>>
>>
>> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-1_Superblock_Format
>>
>> it makes a sound argument for the metadata superblock being at the
>> beginning of the drive.......in a nutshell the kernel can 'construct'
>> the md device easier if the metadata is at the beginning....as well as
>> data resilience issues in the case of a crash.
>
>
> I don't see how you have any choice in case of /boot. I am a strong
> supporter of v1.2 superblock (4k into the partition) as can be seen from the
> discussion about this some years back, but in the case of /boot when the
> boot loader needs to access files on /boot before the raid is started, I
> don't see how you have a choice. So stay away from v0.90, but v1.0 has the
> same functionality apart from where the superblock is placed.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
