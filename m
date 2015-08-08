From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Sat, 08 Aug 2015 11:29:57 -0600
Message-ID: <1526790.RuPxcltSBQ@nell>
References: <1817382.9YhZ7ff5Yl@balsa> <14110213.gd3e4izigE@nell> <alpine.DEB.2.02.1508080809570.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1508080809570.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat Aug 8 2015 08:11:09 AM Mikael Abrahamsson wrote:
> On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:
> > On August 7, 2015 02:38:22 PM Mikael Abrahamsson wrote:
> >> On Thu, 6 Aug 2015, Thomas Fjellstrom wrote:
> >>> Also, sdc has a much lower event count than the other drives, is that
> >>> normal?
> >>> 
> >>> /dev/sdc is the first drive that failed
> >>> /dev/sdb is the one that was kicked after
> >> 
> >> Can you please post dmesg output from when you unplugged the drive and
> >> what happened to the array then? I guess you do not have "cat
> >> /proc/mdstat" from then? It's weird that sdb was busy. Please post mdadm
> >> version and kernel version.
> > 
> > I posted both after the logs in the previous message, but I'll repeat
> > here:
> > 
> > Distro: OpenMediaVault / Debian wheezy
> > Kernel: 3.16.7-ckt4-3~bpo70+1
> > Mdadm: v3.2.5 (from debian) and v3.3.4-22-gccc93b3 - 05th August 2015
> 
> Ah, my bad.
> 
> First, I would recommend you to get the latest mdadm from Neils git
> repository, compile it and try to use --assemble--force using that mdadm
> instead, using the drives with the closest event count.
> 
> Hopefully it will work and not treat the drive as a spare.

I did try that :( It fails to assemble because it only sees sdc as a spare.
Maybe because I did things with the old mdadm first, and did a --remove? That
seems to have wiped out the "slot" information (it's -1) so the assemble force
magic can't figure things out? Just a guess on my part.

root@mrbig:~/build/mdadm# ./mdadm -v --assemble --force /dev/md0 /dev/sd[bdefgh]
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdg is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdh is identified as a member of /dev/md0, slot 6.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: added /dev/sde to /dev/md0 as 3
mdadm: added /dev/sdf to /dev/md0 as 4
mdadm: added /dev/sdg to /dev/md0 as 5
mdadm: added /dev/sdh to /dev/md0 as 6
mdadm: added /dev/sdb to /dev/md0 as -1
mdadm: added /dev/sdd to /dev/md0 as 2
mdadm: /dev/md0 assembled from 5 drives and 1 spare - not enough to start the array.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
