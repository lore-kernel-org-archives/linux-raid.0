From: "H. Peter Anvin" <hpa@zytor.com>
Subject: md bugs discovered during RAID-6 work
Date: 26 Dec 2003 16:37:37 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bsik8h$9nm$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just wanted to let you know that I have found a couple of bugs in
the generic md code while working on RAID-6.  The bugs aren't RAID-6
specific in any way; in fact, I've reproduced them on RAID-1 without
any problems.

a) mdadm -f seems to think it always fails.  This is because the
   ioctl() to set a device faulty returns a positive nonzero value
   which mdadm doesn't expect:

  : raidtest 75 # strace ./mdadm -f /dev/md3 /dev/hde7
  [... generic glibc crap removed ...]
  open("/dev/md3", O_RDWR)                = 3
  fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 3), ...}) = 0
  ioctl(3, 0x800c0910, 0xbffff110)        = 0
  ioctl(3, 0x80480911, 0xbffff150)        = 0
  stat64("/dev/hde7", {st_mode=S_IFBLK|0660, st_rdev=makedev(33, 7), ...}) = 0
  ioctl(3, 0x929, 0x2107)                 = 1
  write(2, "mdadm: set device faulty failed "..., 56
  mdadm: set device faulty failed for /dev/hde7:  Success
  ) = 56
  exit_group(1)                           = ?

  This is mostly an annoyance, although it causes scripts to fail.

b) If an array is running in multi-disk-degraded mode (as can happen
   with RAID-1 or RAID-6), it is not merely possible but quite common
   for all the failed disks to be replaced at approximately the same
   time.

   However, md fails if failed disk #2 is inserted into the array
   before failed disk #1 has finished rebuilding, and will be stuck in
   degraded mode even though spare disks are available to it:

   mdstat during reconstruction:

   md3 : active raid1 hde7[6] hdd7[7] hda7[8] hdi7[2] hdk7[5] hdg7[3]
         987840 blocks [6/3] [__UU_U]
         [==========>..........]  recovery = 54.7% (541184/987840)
         finish=0.2min speed=36078K/sec

   after reconstruction:

   md3 : active raid1 hde7[6] hdd7[7] hda7[0] hdi7[2] hdk7[5] hdg7[3]
         987840 blocks [6/4] [U_UU_U]

   When the second (or third, or...) disk is added, either the
   reconstruction needs to be restarted, *or* once reconstruction is
   finished the md core needs to check again to see if reconstruction
   is warranted, thus triggering multiple reconstruction passes.

   I think the latter is the preferred solution, on the theory that we
   want to get away from "the brink" where actual data loss occurs as
   quickly as possible.  Actually getting the whole array into fully
   functional mode needs to happen, but is less of a priority.

	-hpa

-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
