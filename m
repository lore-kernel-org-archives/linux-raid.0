From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software RAID crash > /dev/md0: Invalid argument
Date: Thu, 16 Sep 2004 14:35:45 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0409161432180.32100@lion.drogon.net>
References: <52074.10.0.0.151.1095334249.squirrel@10.0.0.151>
 <20040916130214.GA21249@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040916130214.GA21249@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Sep 2004, Luca Berra wrote:

> On Thu, Sep 16, 2004 at 07:30:49AM -0400, Scott Bolander wrote:
> >I have a Mandrake 10 server with a 40gb boot drive and a three 200gb disk
> >software raid 5 array using reiserfs.  A disk went bad; so i have replaced
> >it.
> >
> >Doing the normal things to get it back up don't work:
> >
> >[root@server root]#raidhotadd /dev/md0 /dev/hdg
> ....
> ># cat /etc/raidtab
> >raiddev       /dev/md0
> >raid-level    5
> >chunk-size    128k
> >persistent-superblock 1
> >nr-raid-disks 3
> >    device    /dev/hdg1
> >    raid-disk 0
> >    device    /dev/hdi1
> >    raid-disk 1
> >    device    /dev/hdk1
> >    raid-disk 2
> >
> so you replaced the first disk in the array?
> raidtools are not capable of handling this.
> switch to mdadm

Er - Maybe I'm missing something (like the original message in this
thread), but I've successfully used raidtools to raidhotremove and
raidhotadd the first drive (and others) in a raid5 set.., Once on a real
'hot' system, a server with SCSI drives which I didn't power cycle, and on
IDE systems where I've done a sequence of raidhotremove, power down,
change physical drive, boot up, cfdisk new drive, then raidhotadd...

Gordon
