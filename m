From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm --incremental /dev/md?? instead of /dev/md/d??
Date: Tue, 2 Dec 2008 21:39:48 +0100
Message-ID: <200812022139.48935.wilhelm.meier@fh-kl.de>
References: <200811301543.47003.wilhelm.meier@fh-kl.de> <200812010757.31539.wilhelm.meier@fh-kl.de> <18740.50690.3253.790188@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18740.50690.3253.790188@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag 02 Dezember 2008 schrieb Neil Brown:
> On Monday December 1, wilhelm.meier@fh-kl.de wrote:
> > Am Montag 01 Dezember 2008 schrieb NeilBrown:
> > > On Mon, December 1, 2008 1:43 am, Wilhelm Meier wrote:
> > > > How can I switch the naming scheme for the mdadm
> > > > incremental-mode using /dev/md42 instead of /dev/md/d42 for
> > > > adding a device or constructing an array with a minor-number
> > > > 42?
> > >
> > > I thought it did default to /dev/md42
> > > Do you have something like
> > >   CREATE auto=mdp
> > > in /etc/mdadm.conf??
> >
> > no. auto=yes
>
> Hmm.
> Can you show me "mdadm --examine" on one of the drives that you are
> adding with --incremental ??

I had a /dev/md1000 as raid1 with /dev/sdc1 und /dev/sdd1 as 
components. Then I set the /dev/sdd1 to faulty and removed it 
from /dev/md1000. Then I started the --incremental mode 
with /dev/sdd1, assuming I would add it to the /dev/md1000. But this 
did not happen.

Below you find the requested information:

kmux-host:~# mdadm --incremental /dev/sdd1
mdadm: /dev/sdd1 attached to /dev/md/d1000, not enough to start (0).

kmux-host:~# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5f91c408:bd95185c:54631573:9ffde20e (local to host 
kmux-host)
  Creation Time : Tue Dec  2 18:06:39 2008
     Raid Level : raid1
  Used Dev Size : 117218176 (111.79 GiB 120.03 GB)
     Array Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1000

    Update Time : Tue Dec  2 21:29:21 2008
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 541ac935 - correct
         Events : 0.8


      Number   Major   Minor   RaidDevice State
this     2       8       49        2      spare   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      spare   /dev/sdd1
kmux-host:~# mdadm --detail /dev/md1000
/dev/md1000:
        Version : 00.90.03
  Creation Time : Tue Dec  2 18:06:39 2008
     Raid Level : raid1
     Array Size : 117218176 (111.79 GiB 120.03 GB)
  Used Dev Size : 117218176 (111.79 GiB 120.03 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1000
    Persistence : Superblock is persistent

    Update Time : Tue Dec  2 21:33:46 2008
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 5f91c408:bd95185c:54631573:9ffde20e (local to host 
kmux-host)
         Events : 0.18

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       0        0        1      removed
kmux-host:~#                                                                     

kmux-host:~# ls -l /dev/md*
brw-rw---- 1 root disk   9,     0 2008-12-02 14:09 /dev/md0
brw-rw---- 1 root disk   9,     1 2008-12-02 14:09 /dev/md1
brw-rw---- 1 root disk   9,  1000 2008-12-02 18:06 /dev/md1000
brw-rw---- 1 root disk   9,  1001 2008-12-02 14:09 /dev/md1001
brw-rw---- 1 root disk   9,     2 2008-12-02 14:09 /dev/md2
brw-rw---- 1 root disk   9,     3 2008-12-02 21:22 /dev/md3
brw-rw---- 1 root disk 254, 64000 2008-12-02 14:09 /dev/md_d1000
brw-rw---- 1 root disk 254, 64064 2008-12-02 14:09 /dev/md_d1001

/dev/md:
insgesamt 0
brw-rw---- 1 root disk   9,  1000 2008-12-02 14:09 1000
brw-rw---- 1 root disk   9,  1001 2008-12-02 14:09 1001
brw------- 1 root root 254, 64000 2008-12-02 14:09 d1000
brw------- 1 root root 254, 64064 2008-12-02 14:09 d1001
kmux-host:~#                                                      

kmux-host:~# more /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD 
superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
#MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=35895acd:2fb31edb:54e62909:868bea54
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=1adca022:9f6291e6:54e62909:868bea54
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=5d97bf0e:67de158f:54e62909:868bea54
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=9b4dc339:2454fb9a:54e62909:868bea54

# This file was auto-generated on Tue, 25 Nov 2008 06:06:09 +0000
# by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $
#

kmux-host:~# more /etc/mdadm/kmux.conf
ARRAY /dev/md1000 level=raid1 num-devices=2 spares=1 
UUID=5f91c408:bd95185c:54631573:9ffde20e
kmux-host:~#  

-- 
Wilhelm
