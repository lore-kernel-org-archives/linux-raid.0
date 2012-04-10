From: Joe Lawrence <jdl1291@gmail.com>
Subject: mdadm 3.2.3 and adding metadata 1.0 bitmaps
Date: Tue, 10 Apr 2012 15:40:59 +0000 (UTC)
Message-ID: <loom.20120410T165425-854@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I'm testing out RHEL 6.3 Alpha which is shipped with mdadm 3.2.3 and kernel-
2.6.32-257, which may not contain all the latest md bitmap fixes.  Before I go 
diving into the upstream vs. RHEL kernel changes, I thought I would try the list 
first.

The problem I'm seeing is when I try to grow a RAID1 array, adding a write 
intent bitmap to a metadata 1.0 array:


** Add internal write bitmap with metadata=1.0

mdadm --stop /dev/md100
mdadm --zero-superblock /dev/sdc1
mdadm --zero-superblock /dev/sdd1
mdadm --verbose --create /dev/md100 --level=1 --raid-devices=2 --metadata=1.0 
/dev/sdc1 /dev/sdd1

[wait for resync]

mdadm -Gb internal /dev/md100
mdadm: failed to set internal bitmap.

[dmesg]

attempt to access beyond end of device
sdd1: rw=192, want=4297087785, limit=2120517
attempt to access beyond end of device
sdc1: rw=192, want=4297087785, limit=2120517


** Same experiment with metadata=1.0, mdadm-508a7f1 fails.
** Same experiment with metadata=1.1 works fine.


Looking at the changes in super1.c :: add_internal_bitmap1(), I see the switch 
block around the minor_version has changed in mdadm 3.2.3. In the past, the code 
around the comment, /* remove '1 ||' when we can set offset via sysfs */, 
unconditionally set the room value to 6, offset to 2.  In the 3.2.3 version, 
when I try adding the bitmap, may_change is set, room is left at 8, and offset 
0.  Because of the latter, room is recalculated to "start bitmap on a 4K 
boundary with enough space for the bitmap"... bits=17, room=8, and offset=(-8).  
The final little endian / long cast ends up:

	sb->bitmap_offset = (long)__cpu_to_le32(offset);
JL: sb->bitmap_offset = 4294967288

The failing sequence of events were identical with RHEL's version of mdadm 3.2.3 
and the one I grabbed from git (mdadm-508a7f1).  Here is some additional 
information from gdb that might be relevant should this indeed be a bug:


add_internal_bitmap1 (st=0x69a270, chunkp=0x7fffffffccf4, 
    delay=5, write_behind=0, size=2120448, may_change=1, major=4)

(gdb) p *st
$1 = {ss = 0x685c80, minor_version = 0, max_devs = 1920, 
  container_dev = 8388608, sb = 0x6ae000, info = 0x0, ignore_hw_compat = 0, 
  updates = 0x0, update_tail = 0x0, arrays = 0x0, sock = 0, devnum = 100, 
  devname = 0x0, devcnt = 0, retry_soon = 0, devs = 0x0}

(gdb) p *chunkp
$2 = 65534

(gdb) p *sb
$3 = {magic = 2838187772, major_version = 1, feature_map = 0, pad0 = 0, 
  set_uuid = "u=q\fM\024i\036\314M\273\262=\222\006", <incomplete sequence 
\302>,
  set_name = "dhcp-linux-2024-9111:100\000\000\000\000\000\000\000", 
  ctime = 1333741820, level = 1, layout = 0, size = 2120448, chunksize = 0, 
  raid_disks = 2, bitmap_offset = 0, new_level = 0, reshape_position = 0, 
  delta_disks = 0, new_layout = 0, new_chunk = 0, pad1 = "\000\000\000", 
  data_offset = 0, data_size = 2120488, super_offset = 2120496, 
  recovery_offset = 0, dev_number = 0, cnt_corrected_read = 0, 
  device_uuid = ".\177{[\022$\241.31\267\322\305C'\216", devflags = 0 '\000', 
  pad2 = "\000\000\000\000\000\000", utime = 1333741845, events = 17, 
  resync_offset = 18446744073709551615, sb_csum = 1920212589, max_dev = 128, 
  pad3 = '\000' <repeats 31 times>, dev_roles = 0x6ae000}

Regards,

-- Joe Lawrence
   Stratus Technologies


