From: "Dan Merillat" <harik.attar@gmail.com>
Subject: md: bug in file drivers/md/md.c, line 1662
Date: Wed, 3 Jan 2007 06:48:29 +0000
Message-ID: <c0c067900701022248gefa9abbq67c5e91309fd3706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan  3 01:24:12 chaos kernel: [  830.038426] md: bug in file
drivers/md/md.c, line 1662
Jan  3 01:24:12 chaos kernel: [  830.038524]
Jan  3 01:24:12 chaos kernel: [  830.038608]
md:^I**********************************
Jan  3 01:24:12 chaos kernel: [  830.038697] md:^I* <COMPLETE RAID
STATE PRINTOUT> *
Jan  3 01:24:12 chaos kernel: [  830.038787]
md:^I**********************************
Jan  3 01:24:12 chaos kernel: [  830.038879] md0: <sdd2><sdc2><sdb2><sda2>
Jan  3 01:24:12 chaos kernel: [  830.039116] md: rdev sdd2,
SZ:219777152 F:0 S:1 DN:3
Jan  3 01:24:12 chaos kernel: [  830.039206] md: rdev superblock:
Jan  3 01:24:12 chaos kernel: [  830.039297] md:  SB: (V:1.0.0)
ID:<ad8e8baf.00000000.00000000.00000
000> CT:06707edf
Jan  3 01:24:12 chaos kernel: [  830.039448] md:     L-496822052
S00000048 ND:0 RD:0 md0 LO:65536 CS
:196610
Jan  3 01:24:12 chaos kernel: [  830.039547] md:     UT:00000000 ST:0
AD:439554320 WD:0 FD:439554448
 SD:0 CSUM:00000000 E:00000000
Jan  3 01:24:12 chaos kernel: [  830.039700]      D  0:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.039851]      D  1:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.039971]      D  2:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.040093]      D  3:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.040221] md:     THIS:
DISK<N:0,(0,0),R:0,S:0>
Jan  3 01:24:12 chaos kernel: [  830.040345] md: rdev sdc2,
SZ:219777152 F:0 S:1 DN:2
Jan  3 01:24:12 chaos kernel: [  830.040438] md: rdev superblock:
Jan  3 01:24:12 chaos kernel: [  830.040530] md:  SB: (V:1.0.0)
ID:<ad8e8baf.00000000.00000000.00000
000> CT:06707edf
Jan  3 01:24:12 chaos kernel: [  830.040683] md:     L-496822052
S00000048 ND:0 RD:0 md0 LO:65536 CS
:196610
Jan  3 01:24:12 chaos kernel: [  830.040782] md:     UT:00000000 ST:0
AD:439554320 WD:0 FD:439554448
 SD:0 CSUM:00000000 E:00000000
Jan  3 01:24:12 chaos kernel: [  830.040932]      D  0:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.041083]      D  1:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.042321]      D  2:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.042441]      D  3:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.042564] md:     THIS:
DISK<N:0,(0,0),R:0,S:0>
Jan  3 01:24:12 chaos kernel: [  830.042687] md: rdev sdb2,
SZ:219777152 F:0 S:1 DN:1
Jan  3 01:24:12 chaos kernel: [  830.042779] md: rdev superblock:
Jan  3 01:24:12 chaos kernel: [  830.042870] md:  SB: (V:1.0.0)
ID:<ad8e8baf.00000000.00000000.00000
000> CT:06707edf
Jan  3 01:24:12 chaos kernel: [  830.043022] md:     L-496822052
S00000048 ND:0 RD:0 md0 LO:65536 CS
:196610
Jan  3 01:24:12 chaos kernel: [  830.043121] md:     UT:00000000 ST:0
AD:439554320 WD:0 FD:439554448
 SD:0 CSUM:00000000 E:00000000
Jan  3 01:24:12 chaos kernel: [  830.043274]      D  0:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.043424]      D  1:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.043544]      D  2:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.043666]      D  3:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.043792] md:     THIS:
DISK<N:0,(0,0),R:0,S:0>
Jan  3 01:24:12 chaos kernel: [  830.043917] md: rdev sda2,
SZ:219777152 F:0 S:1 DN:0
Jan  3 01:24:12 chaos kernel: [  830.044009] md: rdev superblock:
Jan  3 01:24:12 chaos kernel: [  830.044095] md:  SB: (V:1.0.0)
ID:<ad8e8baf.00000000.00000000.00000
000> CT:06707edf
Jan  3 01:24:12 chaos kernel: [  830.044235] md:     L-496822052
S00000048 ND:0 RD:0 md0 LO:65536 CS
:196610
Jan  3 01:24:12 chaos kernel: [  830.044327] md:     UT:00000000 ST:0
AD:439554320 WD:0 FD:439554448
 SD:0 CSUM:00000000 E:00000000
Jan  3 01:24:12 chaos kernel: [  830.044467]      D  0:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.044612]      D  1:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.044727]      D  2:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.044843]      D  3:
DISK<N:-1,(-1,-1),R:-1,S:-1>
Jan  3 01:24:12 chaos kernel: [  830.044963] md:     THIS:
DISK<N:0,(0,0),R:0,S:0>
Jan  3 01:24:12 chaos kernel: [  830.045078]
md:^I**********************************
Jan  3 01:24:12 chaos kernel: [  830.045163]

repeated over and over.

kernel 2.6.19.1 with SATA drives on a promise tx4 300 controller.


Which leads to this code:
    if (!mddev->events) {
        /*
         * oops, this 64-bit counter should never wrap.
         * Either we are in around ~1 trillion A.C., assuming
         * 1 reboot per second, or we have a bug:
         */
        MD_BUG();
        mddev->events --;
    }

... which seems wrong to me.  if mddev->events==0, won't
mddev->events-- cause it to wrap around again shortly?

Order of events:
Create raid5 1 drive short, realize resync will take forever, delete raid5,
re-create with 'assume clean', add spare, grow into the spare,
decide it will still take too long on a 750gb array, delete the whole thing
re-create with assume-clean, realize I need non-software-raid
partition for booting,
delete, repartition, re-create, allow it to  work on resync this time.

Copy data, reboot to pull the old drives out (resync not completed),
can't boot because of old buggy motherboard, use a rescue kernel
(2.6._18_.1) it refuses to start the array with --assemble, due to the
integer overflow.

Yes, it was not pretty,  I was testing the different parts of mdadm
before entrusting my data to it.

I did solve the problem: zeroed the superblocks, created with a
missing drive and hot-added it, now it's rebuilding with no more
kernel errors.  Event counter is  at 879 now, so that should be ok.
I'll see how it handles a reboot and autostart tomorrow.

--Dan
