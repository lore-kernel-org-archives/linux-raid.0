From: "Calvin D. Webster" <cwebster@ec.rr.com>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Wed, 22 May 2002 08:00:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CEB8862.E114F042@ec.rr.com>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
		<NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com>
		<15594.45618.113616.670740@notabene.cse.unsw.edu.au>
		<3CEAC664.8D738EC2@ec.rr.com> <15594.56731.169389.603464@notabene.cse.unsw.edu.au>
Reply-To: cwebster@ec.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Tuesday May 21, cwebster@ec.rr.com wrote:
> >
> > There is only one thing that doesn't look right to me. That is the
> > contents of "/proc/mdstat".
> > The device numbers seem mismatched to their device names.
> 
> I don't know what caused the different numbering.  However as the raid
> drive is clearly putting the right disks in the right places I
> wouldn't worry about it.

There were a few other minor inconsistencies that I thought you might be
interested in between the output of "mdadm" and that of "lsraid" from
the new raidtools.


"mdadm --examine /dev/sda1" shows "State : dirty, no-errors". All other
RAID drives show the same.

"lsraid -D -a /dev/md0" shows "state		= good". All other RAID devices
show the same.

## Possibly related: 

## Because of this inconsistency, I ran "e2fsck /dev/md0":

-------------------------------------------------------------------------
[root@winggear root]# e2fsck /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
/dev/md0: clean, 69960/8847360 files, 9835985/17681664 blocks
-------------------------------------------------------------------------

## Okay, it says "clean" but I'm not buying it. Try "force"

-------------------------------------------------------------------------
[root@winggear root]# e2fsck -f /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Filesystem contains large files, but lacks LARGE_FILE flag in
superblock.
Fix<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/md0: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md0: 69960/8847360 files (1.0% non-contiguous), 9835985/17681664
blocks
-------------------------------------------------------------------------

## I wonder why the LARGE_FILE flag was not set?

## I wonder if there is something else not quite right in the superblock
causing "mdadm" to report "dirty".

Everything seems to be running okay, though. The system will be getting
some exercise today. I should know soon if there are any problems. Let
me know if you'd like for me to check anything.

--Cal Webster
