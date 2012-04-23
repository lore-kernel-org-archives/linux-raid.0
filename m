From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Raid5 crashed, need comments on possible repair solution
Date: Mon, 23 Apr 2012 15:56:16 +0200
Message-ID: <4F955F80.80903@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Linux RAID worked for me fine in the last few years, but yesterday while
reorganizing the HW in my server the RAID5 crashed. It was a
Software-RAID Level 5 with 6x 3TB drives and ran XFS on top of it. I
have no idea why it crashed, but now all superblocks are invalid (one
dump follows) and sadly i have no information on the raid disk layout
(in which sequence the drives were). All drives from the raid are
available and running.

As i cannot afford to buy 6x more drives for making a backup prior
trying to fix the situation, i need a non-destructive approach to fix
the RAID configuration and the superblocks.

From my understanding of the RAID5 implementation the correct order of
drives is important.

First Question:
1) Am i right that the order is important and i have to try to find the
right sequence of drives?

So i would create a loop over all permutations of the drive list and for
each permutation:
- Scrub the Superblock mdadm --zero-superblock /dev/sd[bcdefg]1
- Recreate the RAID5 mdadm --create /dev/md0 -c 64 -l 5 \
	-n 6 --assume-clean <drive permutation>
- Run xfs_check to see if it recognizes the FS xfs_check -s /dev/md0
- Stop the RAID mdadm --stop /dev/md0

2) Is that a promising approach to repair the RAID5 array?
3) According the man page the --assume-cleanthat no data is affected
unless you write to the array, so this effectively prevents a rebuild?
This is important for me, as i don't want to trigger a rebuild as this
will certainly send my data to hell.
4) Any other idea for repairing the RAID without loosing user data?

Thanks in advance for any answers.


Currently the RAID superblocks on each device look like this:

/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 53a294b5:975244fc:343b0f94:16652fce
           Name : grml:0
  Creation Time : Fri Apr 15 20:55:52 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 5860529039 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 9688dc72:02140045:c16a2123:4f6cc006

    Update Time : Sun Apr 22 23:56:14 2012
       Checksum : 350d8d74 - correct
         Events : 1


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


Interestingly at the Update Time the system should have been shut down:
Apr 22 23:55:55 router init: Switching to runlevel: 0
[...]
Apr 22 23:56:03 router exiting on signal 15
Apr 22 23:59:21 router syslogd 1.5.0: restart.

I have really no clue what happened.


Regards

Christoph Nelles

-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt

