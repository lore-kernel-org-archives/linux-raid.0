From: Novak David-DNOVAK1 <David.Novak@motorola.com>
Subject: RE: Linear Raid Problems...
Date: Fri, 2 Apr 2004 13:35:57 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8E4E38BF6D087F4488E80ABAACA2F3F484D64D@il27exm02.cig.mot.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmmm...Nope, mdadm didn't like --raid-devices.  It looks like it's finding
all the drives OK, but when it actually puts the device into service with 
the run command, that's when it's puking.

Should I not have fdisk'ed the drives?  I assumed that they needed SOME 
sort of formating.

I just noticed this in my syslog:
Apr  2 12:57:13 Homer kernel: md: bind<sdb1,1>
Apr  2 12:57:13 Homer kernel: md: bind<sdc1,2>
Apr  2 12:57:13 Homer kernel: md: bind<sdd1,3>
Apr  2 12:57:13 Homer kernel: md: sdd1's event counter: 00000000
Apr  2 12:57:13 Homer kernel: md: sdc1's event counter: 00000000
Apr  2 12:57:13 Homer kernel: md: sdb1's event counter: 00000000
Apr  2 12:57:13 Homer kernel: md: personality 1 is not loaded!
Apr  2 12:57:13 Homer kernel: md: md0 stopped.
Apr  2 12:57:13 Homer kernel: md: unbind<sdd1,2>
Apr  2 12:57:13 Homer kernel: md: export_rdev(sdd1)
Apr  2 12:57:13 Homer kernel: md: unbind<sdc1,1>
Apr  2 12:57:13 Homer kernel: md: export_rdev(sdc1)
Apr  2 12:57:13 Homer kernel: md: unbind<sdb1,0>
Apr  2 12:57:13 Homer kernel: md: export_rdev(sdb1)

OK.  So I'm 99.99% sure that the personality (linear) is not loaded.
Question:
Where is this personality located?
Where do I get this personality from?
How do I load this personality?

  Thanks again!
  David

-------
David J.  Novak                           GSM Radio Firmware
GSM Products Division                     CE/NSS
Motorola                                  Life v7.0
--------------------------------------------------------------------------
"Not all who wander are lost." - J.R.R. Tolkien

-----Original Message-----
From: Guy [mailto:bugzilla@watkins-home.com]
Sent: Friday, April 02, 2004 1:14 PM
To: Novak David-DNOVAK1; linux-raid@vger.kernel.org
Subject: RE: Linear Raid Problems...


Personality...
I have never needed to talk any steps to install personalities.

Did you check the logs for any info?

Maybe replace:
	--raid-disks=3
With
	--raid-devices=3

If this is the issue, maybe mdadm sucks!  :)
At least the error message sucks!

RAID0 should give better performance over linear.  With RAID0 the array will
be striped across all 3 disks, as much as can be.  With linear the 3 disks
are used 1 after the other.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Novak David-DNOVAK1
Sent: Friday, April 02, 2004 12:35 PM
To: linux-raid@vger.kernel.org
Subject: RE: Linear Raid Problems...

Thanks for the quick response Guy,

  Here's some more info for you.  Here's the output of the dd stuff:
Homer:/# dd if=/dev/sdc of=/dev/null bs=64k
65533+1 records in
65533+1 records out
Homer:/# dd if=/dev/sdb of=/dev/null bs=64k
138197+1 records in
138197+1 records out
Homer:/# dd if=/dev/sdd of=/dev/null bs=64k
32773+1 records in
32773+1 records out

That looks OK to me.  So I added the mdadm package (so nobody would yell),
and tried this:

Homer:/# mdadm --create /dev/md0 --chunk=64 --level=linear --raid-disks=3
/dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: /dev/sdb1 appears to contain an ext2fs file system
    size=8841040K  mtime=Thu Apr  1 18:22:11 2004
mdadm: /dev/sdc1 appears to contain an ext2fs file system
    size=4194156K  mtime=Thu Apr  1 18:23:00 2004
mdadm: /dev/sdd1 appears to contain an ext2fs file system
    size=2076320K  mtime=Thu Apr  1 18:23:19 2004
Continue creating array? y
mdadm: RUN_ARRAY failed: Invalid argument
Homer:/#

Then:
Homer:/# cat /proc/mdstat
Personalities :
read_ahead not set
unused devices: <none>
Homer:/#

Do I not have the correct "personality" loaded?  How do I check that?  
If I don't have it loaded, how do I load it?  Thanks again!

  David
-------
David J.  Novak                           GSM Radio Firmware
GSM Products Division                     CE/NSS
Motorola                                  Life v7.0
--------------------------------------------------------------------------
"Not all who wander are lost." - J.R.R. Tolkien

-----Original Message-----
From: Guy [mailto:bugzilla@watkins-home.com]
Sent: Friday, April 02, 2004 8:55 AM
To: Novak David-DNOVAK1; linux-raid@vger.kernel.org
Subject: RE: Linear Raid Problems...


Looks like you have a bad disk!
Apr  2 07:47:39 Homer kernel:  I/O error: dev 08:21, sector 23758976

I test my disks with the dd command.
Examples:
To test the whole disk:
	dd if=/dev/sdb of=/dev/null bs=64k
To test one partition:
	dd if=/dev/sdb1 of=/dev/null bs=64k

I would test the whole disk.

It looks like your array is assembled, but not started.
Try:
raidstop /dev/md0
mkraid /dev/md0

You should consider switching from mkraid to mdadm.
Most people here will YELL at you for using mkraid! :)
For details:
man mdadm

In a related issue, you should consider using RAID5.  You will lose the
space of one disk.  However, if a disk fails no data loss and the data is
accessible.

Oops... I see your disks have very different sizes.  Don't use RAID5!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Novak David-DNOVAK1
Sent: Friday, April 02, 2004 9:27 AM
To: 'linux-raid@vger.kernel.org'
Subject: Linear Raid Problems...

Hi all,

  Sorry, but this message might be a tad long.  But I'm running an 
UltraSparc Debian Linux (with SMP!).  Anyway, I've got a few extra disks I 
want to span into one Uber-partion, and figured Software RAID (linear) was 
the way to go.  I've read the howto's and the faq's, and thought I was 
doing everything right...but alas something is amiss, and I implore for the 
Linux community's help.  Here's my setup:

/etc/raidtab:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   3
        chunk-size      32
        persistent-superblock 1
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1
        device          /dev/sdd1
        raid-disk       2

mkraid command:

Homer:/etc# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdb1, 8841042kB, raid superblock at 8840960kB
disk 1: /dev/sdc1, 11879560kB, raid superblock at 11879488kB
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

mkraid version:
Homer:/etc# mkraid --version
mkraid version 0.90.0

Kernel version:
Homer:/etc# cat /proc/version
Linux version 2.4.19 (root@hopper) (gcc version egcs-2.92.11 19980921 (gcc2
ss-9
80609 experimental)) #1 SMP Fri Oct 4 19:11:01 EDT 2002

After running mkraid they syslog says:
Apr  2 07:47:39 Homer kernel:  I/O error: dev 08:21, sector 23758976

In desperation tried:
mkraid --really-force /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdb1, 8841042kB, raid superblock at 8840960kB
disk 1: /dev/sdc1, 11879560kB, raid superblock at 11879488kB
disk 2: /dev/sdd1, 2076320kB, raid superblock at 2076224kB
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

Then syslog says:
Apr  2 07:50:18 Homer kernel: md: array md0 already exists!

Which is weird because that exact command didn't work last night...
but now mdstat says:

Homer:/etc# cat /proc/mdstat
Personalities :
read_ahead not set9L, 906C                                    1,1
All
md0 : inactive sdd1[2] sdc1[1] sdb1[0]
      0 blocks
unused devices: <none>

Which is weird, because last night it didn't say that...

So I think the kernel thinks it's there right, but when I do an fdisk:
Homer:/# fdisk /dev/md0
Unable to read /dev/md0

Or if I try to create a fs:
Homer:/# mkfs.ext3 /dev/md0
mke2fs 1.27 (8-Mar-2002)
mkfs.ext3: Device size reported to be zero.  Invalid partition specified, or
        partition table wasn't reread after running fdisk, due to
        a modified partition being busy and in use.  You may need to reboot
        to re-read your partition table.

I think that's all the data somebody really smart might need to diagnose my 
problem.  Thanks in advance for any info!

  David

-------
David J.  Novak                           GSM Radio Firmware
GSM Products Division                     CE/NSS
Motorola                                  Life v7.0
--------------------------------------------------------------------------
"Not all who wander are lost." - J.R.R. Tolkien
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

