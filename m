From: Vinnie <listacct1@lvwnet.com>
Subject: Re: HELP - need more documentation on using partitioned (mdp-type) md devices
Date: Tue, 05 Nov 2002 00:59:17 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC75E35.4090405@lvwnet.com>
References: <3DC7432B.304@lvwnet.com> <15815.18944.139723.503440@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

 > On Monday November 4, listacct1@lvwnet.com wrote:
 >
 >>If anybody (Neil?) can offer some advice on how to get LILO to write a
 >>boot sector to the RAID1 array pair, it would be greatly appreciated.  I
 >>am so close to getting this working!!!
 >>
 >>
 >
 > First, lilo thinks it knows what "/dev/md*" means, and gets all
 > confused when it turns out to be different.
 > So create device names that *don't* start /dev/md.
 > e.g.
 >    /dev/MDa == 60,0
 >    /dev/MDa1 == 60,1
 >    etc
 >
 > Second, you have to tell lilo about the geometry of /dev/MD*, because
 > it doesn't know:
 >
 >    boot=/dev/MDa
 >    disk=/dev/MDa
 >      bios=0x80
 >      sectors=63
 >      heads=255
 >      cylinders=1024
 >      partitions=/dev/MDa1
 >       start=63
 >
 > The "start" is very important.  check what the start sector of MDa1
 > is, and use that.
 >
 > Lilo should then work.
 >
 > NeilBrown


thanks Neil!  Getting ready to try this out.  This looks really
promising, makes a lot of sense.

Vince





