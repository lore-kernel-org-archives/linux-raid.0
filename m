From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: HELP - need more documentation on using partitioned (mdp-type) md devices
Date: Tue, 5 Nov 2002 15:33:04 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15815.18944.139723.503440@notabene.cse.unsw.edu.au>
References: <3DC7432B.304@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Vinnie on Monday November 4
To: Vinnie <listacct1@lvwnet.com>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday November 4, listacct1@lvwnet.com wrote:
> 
> If anybody (Neil?) can offer some advice on how to get LILO to write a 
> boot sector to the RAID1 array pair, it would be greatly appreciated.  I 
> am so close to getting this working!!!
> 

First, lilo thinks it knows what "/dev/md*" means, and gets all
confused when it turns out to be different.
So create device names that *don't* start /dev/md.
e.g.
   /dev/MDa == 60,0
   /dev/MDa1 == 60,1
   etc

Second, you have to tell lilo about the geometry of /dev/MD*, because
it doesn't know:

   boot=/dev/MDa
   disk=/dev/MDa
     bios=0x80
     sectors=63
     heads=255
     cylinders=1024
     partitions=/dev/MDa1
      start=63

The "start" is very important.  check what the start sector of MDa1
is, and use that.

Lilo should then work.

NeilBrown
