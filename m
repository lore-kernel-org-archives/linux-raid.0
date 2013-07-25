From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 17:52:15 -0400
Message-ID: <51F19E0F.5000400@tmr.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roberto Spadim wrote:
> Hi guys i have a server with two 500gb hdd (enterprise sata 7200rpm)
> It's a dell R210 II Server, intel e3 1220v2 processor
> There's no raid card just mainboard, disk, ram memory (8gb) and four
> network interfaces (internet and bond of local network)
> I will use it as a server (mariadb,php,apache) with slackware linux
> and kernel 3.9.10, mariadb with aria storage.
> I think kernel 3.10.2 isn't nice yet to work with raid1, it have some
> bugs, right?
>
I don't think this is a bad choice, although the 3.10 may be a bit faster for 
many CPU bound processes, even if only for ms at a time. If you like it better 
it's a good choice.

> Well the system setup...
>
> I want 4 partitions in each disk
> /boot with 200mb, xfs filesystem and raid1
> swap with 20gb (or 10gb),
> / with 100gb, xfs filesystem and raid1
> /home with all disk left (near to 400gb), xfs filesystem and raid1
>
Other people have mentioned not using two filesystems to prevent thrashing and 
head motion, The only thing in root which changes a lot are logs, and then only 
when comthing log generating is running. Certainly http, nntp, and mail servers 
qualify. Unless you see some reason I missed, joining all the root and home in 
one filesystem will probably be a win over having two.

> No lvm, i will not expand filesystem, just replace disk when it crash
> (maybe next 4 to 5 years), i will not expand hardware, just replace
> when crashed too (network card, memory, cpu, etc)
> After 5 year i think that will have ~100GB in /home or less
>
> I tested this system in raid1, raid10, raid5 and raid6, with last
> archlinux, the best performace was raid1

I note the lack of raid10, particularly raid10 with -f2 (far two) layout. In 
general that is going to be faster than raid1, and equally robust. You ran a lot 
of benchmarks, one more would config your choice or give you a better option.

> There's many non sequencial writes, with many thread reading/writing
> to disk, that's the main reason that i think raid1 worked better
>
> Now the point is, what's the best fdisk, mdadm, mkfs_xfs, tunefs,
> smartctl and others tune tools and /sys /proc parameters?
> I want a good align and performace
>
Then you can play with hardware and software readahead, stride, all the 
write{back,thru,etc} options xfs may provide. Frankly, if you want good disk 
performance, the most time effective thing you can do is add more drives to 
spread the head motion and do more parallel i/o. With only two drives and raid1 
you are limited to the transfer rate of the slowest drive and sequential seeks. 
with more spindles you start to do things in parallel, use the outer part of the 
drive for faster transfer, etc. What you have has a low theoretical max which 
you can beat without tuning using more disk and raid10.

> What more information should i share?

Write size. The will effect your chunk size choices. I don't know what xfs gives 
you in control of favoring writes of a given size, ext4 does let you provide 
information to the kernel in extended options, which can be useful. In my 
experience more so when doing a series of sequential small writes (more than a 
chunk total, not huge) than a ton of small scattered writes, just mentioning 
things you can evaluate, since you have put a lot of work into test already.

> Thanks guys
>
> --
> Roberto Spadim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
