From: Gordon Henderson <gordon@drogon.net>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Tue, 17 Oct 2006 11:44:55 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-poweredge@dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


For anyone who cares about my saga so-far ;-) ...

I got physical access to the unit this morning and setup the drives as 15
RAID-0 Logical drives and booted up Linux, and it then attached all the
drives in the usual way.

And I can see all 15 drives. So the down-side is that I can't use any sort
of SMART stuff over the bus (as pointed out by someone else).

Anyway, it's currently in a RAID-1 configuration (which I used for some
initial soaktests) and seems to be just fine:

Filesystem            Size  Used Avail Use% Mounted on
/dev/md9              6.8T   33M  6.7T   1% /mnt

And it's more than fast enough too, although it'll be a lot slower when I
rebuilt it in RAID-6 mode.

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
bertha           2G           266336  99 203934  61           421850  40 872.9   1


md9 : active raid0 sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[9] sdi[8]
sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda[0]
      7317748800 blocks 64k chunks

Cheers,

Gordon
