From: Jon Forrest <jlforrest@berkeley.edu>
Subject: mdadm: ADD_NEW_DISK failed: Invalid argument
Date: Thu, 03 Feb 2011 16:31:19 -0800
Message-ID: <iifhb6$inv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(I see that other people have had this problem
but not in the same situation as me. Mine
is probably as simple as you can get).

I'm learning about how to manage software raid
by using loopback devices on a RHEL6 system
(2.6.32-71.14.1.el6.i686).

I create two loopback devices thusly:

# dd if=/dev/zero of=file0 bs=1k count=100
100+0 records in
100+0 records out
102400 bytes (102 kB) copied, 0.000689998 s, 148 MB/s
# cp file0 file1
# losetup /dev/loop0 file0
# losetup /dev/loop1 file1

I can create a RAID1 volume with no problems:

# mdadm --create /dev/md0 --raid-device=2 --level=1 /dev/loop0 /dev/loop1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

However, doing the same thing but creating a RAID0 volume
fails thusly:

# dd if=/dev/zero of=file2 bs=1k count=100
100+0 records in
100+0 records out
102400 bytes (102 kB) copied, 0.000699377 s, 146 MB/s
# cp file2 file3
# losetup /dev/loop2 file2
# losetup /dev/loop3 file3
# mdadm --create /dev/md1 --raid-device=2 --level=0 /dev/loop2 /dev/loop3
mdadm: Defaulting to version 1.2 metadata
mdadm: ADD_NEW_DISK for /dev/loop2 failed: Invalid argument

I don't understand what went wrong? Any ideas?

Cordially,
-- 
Jon Forrest
Research Computing Support
College of Chemistry
173 Tan Hall
University of California Berkeley
Berkeley, CA
94720-1460
510-643-1032
jlforrest@berkeley.edu

