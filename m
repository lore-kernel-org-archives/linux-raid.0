From: "Garth Snyder" <garth@grsweb.us>
Subject: Spare fails to transfer between RAID groups
Date: Sun, 10 May 2009 23:33:44 -0700
Message-ID: <001901c9d202$709acad0$51d06070$@us>
Reply-To: <garth@grsweb.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi raiders --

I'm having a problem getting a spare partition moved to the right RAID group
after a failure. I see some past discussion of issues related to spare
groups in the list archive, but no exact fit for the behavior I'm seeing.
Here's the outline:

1) Two RAID arrays (/dev/md_d0 and /dev/md_d3) are assigned to one
spare-group in /etc/mdadm/mdadm.conf. The spare partition is initially
assigned to /dev/md_d0.

2) I use mdadm --fail to fail a disk that belongs to the nondefault RAID
group, /dev/md_d3. (This is a testing scenario, not an actual failure.)

3) mdadm --monitor is running and working correctly, as evidenced by email
noting the Fail event on /dev/md_d3.

4) The spare partition is successfully removed from its original RAID group,
/dev/md_d0.

5) The spare partition is never added to /dev/md_d3, nor is it returned to
its original group, /dev/md_d0.

6) Two error messages are submitted via syslog to /var/log/kern.log in quick
succession, both with the same message: "HOT_ADD may only be used with
version-0 superblocks". The first message is tagged "md_d3" and the second
"md_d0".

7) There are no other syslog messages or developments. /dev/md_d3 remains
degraded.

8) The system is Ubuntu Jaunty Jackalope, kernel  2.6.28-11-generic, mdadm
--version = v2.6.7.1 - 15th October 2008.

From the error messages, I gather that the issue occurs when adding the
spare to the new array. After that proves impossible, mdadm tries to return
the spare to its original array, but that fails too. The weird things is
that "mdadm /dev/md_d3 --add /dev/sdc1" works just fine when run by hand, as
does the analogous command to return /dev/sdc1 to /dev/md_d0.

All superblocks involved are version 1.2. This is a new setup, and every
mdadm --create command has included --metadata=1.2. There should be no
legacy or old RAID superblocks around.

Any help or pointers would be appreciated. Is there some limitation I'm not
aware of that's preventing the hot add?

Thanks,
Garth

Some details:

/etc/mdadm/mdadm.conf:

DEVICE /dev/sd[abcehi][1234] /dev/sd[dgf][12356] /dev/hfspare/hfspare1
/dev/hfspare/hfspare2
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR garth@grsweb.us
ARRAY /dev/md_d0 level=raid10 metadata=1.2 num-devices=3
UUID=c766cb59:4e5fc5f6:509aac41:fa5c9c45 name=nutrient:evolution1
spare-group=evonent
ARRAY /dev/md_d3 level=raid5 metadata=1.2 num-devices=3
UUID=d4c020c9:4e5fc5f6:509aac41:fa5c9c45 name=nutrient:entgegen
spare-group=evonent
[other RAID arrays omitted]

/proc/mdstat, right after /dev/sde1 is failed:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10] 

md0 : active raid10 sdg2[1] sdf2[2] sdd2[0] sdc1[3](S)
      468756288 blocks super 1.2 64K chunks 2 far-copies [3/3] [UUU]
      
md4 : active raid5 sdg6[1] sdf6[2] sdd6[0] sda4[4]
      516216192 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4]
[UUUU]
      
md1 : active raid5 sdf3[2] sdg3[1] sdd3[0] sde2[5] sda2[3]
      312495872 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
[UUUUU]
      
md2 : active raid5 sdf5[2] sdg5[1] sdd5[0] sda3[4]
      1230465984 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4]
[UUUU]
      
md3 : active raid5 sde1[1](F) sda1[0] sdh1[3]
      624992384 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/2] [U_U]


