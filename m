From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID1 + rsync (2)
Date: Fri, 13 Aug 2004 19:26:40 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411CDDB0.6010003@tls.msk.ru>
References: <1092387262.3113.10.camel@localhost> <Pine.LNX.4.56.0408131052450.480@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408131052450.480@lion.drogon.net>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gordon Henderson wrote:
[]
> Heres a scenario that I use myself. Firstly I'm not a fan of a separate
> /boot partition - thats all to do with me being a boring old fart and new
> hardware not needing it... So..
> 
> If you partition all 4 disks identically it'll save you headaches later
> when you need to replace one.
> 
> So I'd do it like this:
> 
> 6 partitions: The first used as root, 2nd as swap, 3rd as /usr, 4th as
> /var 5th as your data and 6th as the backup for the data. You can combine
> root and /var and even /usr if you like to make it simpler. There are pros
> and cons for each way. (as well as holy wars)
> 
> Combine the root partitions together with RAID1 and 2 hot-spares. All
> others in RAID5. (including swap, yes, I know, not efficient, but if you
> are swapping heavilly you are runing sub-optimally in the first place -
> buy more memory!)

That's excellent advise.  Here's some more suggestions.

o if you use identical disks, number your mdN devices after the partition
   number (md1 on sd[abcd]1, md5 on sd[abcd]5 etc) - this makes life a
   bit easier, and in particular makes hot-adding of new disk easier:

    for i in 1 2 3 5 6 7 8 ...; do
      mdadm --add /dev/md$i /dev/sdd$i
    done

o instead of raid5, use raid1+0 for swap.  That is, create two raid1
   arrays - md20 on sd[ac]2 and md21 on sd[bd]2, and list both
   md20 and md21 as swap devices in fstab.

o keep your root filesystem on the first partition on every disk,
   without spares, i.e. build raid1 array out of all 4 disks.  It
   is ok to have very small root partition, e.g 256Mb should be
   sufficient (provided /usr and the rest are separate partitions).
   This way, you will be able to boot of any disk (with or without
   md1 running), and you will have sufficient tools to recover after
   any problem.  Ofcourse, /boot will be keept in /.

So, the "final layout" (I use it on many my systems) looks like:

  md1  raid1 on sd[abcd]1  root 256Mb (active partition)
  md20 raid1 on sd[ac]2    swap
  md21 raid1 on sd[bd]2    swap
  md3  raid5 on sd[abcd]3  /usr
  md5  raid5 on sd[abcd]5  /var
  md6  raid5 on sd[abcd]6  /home
  ...

or something like that:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md1                124323     86893     31011  74% /
/dev/md2               4434560   1867950   2341318  45% /usr
/dev/md5               2205258    793952   1299274  38% /var
/dev/md6               8845860   4512008   3884458  54% /home
...

/mjt
