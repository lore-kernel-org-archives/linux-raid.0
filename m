From: Roberto Spadim <roberto@spadim.com.br>
Subject: Help creating filesystem (xfs) and partitioning
Date: Tue, 23 Jul 2013 21:06:24 -0300
Message-ID: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys i have a server with two 500gb hdd (enterprise sata 7200rpm)
It's a dell R210 II Server, intel e3 1220v2 processor
There's no raid card just mainboard, disk, ram memory (8gb) and four
network interfaces (internet and bond of local network)
I will use it as a server (mariadb,php,apache) with slackware linux
and kernel 3.9.10, mariadb with aria storage.
I think kernel 3.10.2 isn't nice yet to work with raid1, it have some
bugs, right?

Well the system setup...

I want 4 partitions in each disk
/boot with 200mb, xfs filesystem and raid1
swap with 20gb (or 10gb),
/ with 100gb, xfs filesystem and raid1
/home with all disk left (near to 400gb), xfs filesystem and raid1

No lvm, i will not expand filesystem, just replace disk when it crash
(maybe next 4 to 5 years), i will not expand hardware, just replace
when crashed too (network card, memory, cpu, etc)
After 5 year i think that will have ~100GB in /home or less

I tested this system in raid1, raid10, raid5 and raid6, with last
archlinux, the best performace was raid1
There's many non sequencial writes, with many thread reading/writing
to disk, that's the main reason that i think raid1 worked better

Now the point is, what's the best fdisk, mdadm, mkfs_xfs, tunefs,
smartctl and others tune tools and /sys /proc parameters?
I want a good align and performace

What more information should i share?
Thanks guys

--
Roberto Spadim
