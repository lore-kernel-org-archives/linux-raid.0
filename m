From: linux-raid2eran@tromer.org
Subject: Slow software RAID5
Date: Fri, 15 Oct 2004 15:23:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ckoj1a$pls$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060801000508090605060001"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060801000508090605060001
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

I have a Linux box running a software RAID5 array of 3 IDE disks. Each
disk, by itself, has a sequential read bandwidth of over 40MB/sec.
I thus expect the sequential read bandwidth of the RAID array to be at
least 80MB/sec, but it's much lower (e.g., 26MB/sec for 128K chunk and
64K lookahead). What could be wrong?

Attached is a file listing the read and write bandwidth near the
beginning of the array (as measured by timing 'dd bs=64k ...') for
various chunk sizes, lookahead sizes and degraded modes. As you can see,
it never approaches the theoretical 80MB/sec --- except in some degraded
modes.

Each drive is connected as master on a separate IDE channel with no
slave. The 3 drives are of different brands, all 7200RPM, all ATA/100 or
better. CPU usage is low, nothing else is accessing the disks, the 1GB
of RAM is mostly unused and there's no array sync in progress. Running
vanilla Linux 2.6.8.1 on Fedora Core 2.

Curiously, if I remove one of the drives from the array
("mdadm --fail ...") and run in degraded mode, the bandwidth greatly
increases. Likewise, RAID4 is significantly faster.

One theory is that the reads are slowed in non-degraded RAID5 because
they're not contiguous (the parity chunks are skipped). But I
think a huge lookahead would have fixed that. It doesn't, even when the
readahead is larger than a full stripe.

Another theory is that the disks, being of different models, get out of
sync; again, a huge lookahead should have fixed that (65536 sectors
lookahead is much larger than tracksize*#disks), but doesn't. But then,
with that lookahead sequential read bandwidth is lower than with smaller
lookaheads, which doesn't make much sense anyway.

Any ideas?

  Eran


--------------060801000508090605060001
Content-Type: text/plain;
 name="raidperf.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raidperf.txt"

With readahead of 128 blocks (on both /dev/hd? and /dev/md?):

RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 46.135222 MB/sec      write: 39.887844 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 47.709570 MB/sec      write: 36.555040 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 48.440246 MB/sec      write: 38.898690 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 45.970336 MB/sec      write: 38.828235 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 45.173847 MB/sec      write: 33.991808 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 28.513893 MB/sec      write: 34.574373 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 37.830947 MB/sec      write: 32.963090 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 35.472600 MB/sec      write: 28.127734 MB/sec
RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 59.807037 MB/sec      write: 38.380247 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 62.257986 MB/sec      write: 37.675747 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 65.225659 MB/sec      write: 33.920095 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 60.940461 MB/sec      write: 32.236842 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 59.110754 MB/sec      write: 35.835345 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 44.908054 MB/sec      write: 34.975526 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 41.654070 MB/sec      write: 30.112395 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hda5)
  read: 45.122807 MB/sec      write: 24.445571 MB/sec
RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 75.513699 MB/sec      write: 47.311795 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 88.462861 MB/sec      write: 44.733944 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 83.198577 MB/sec      write: 38.626126 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 88.422319 MB/sec      write: 39.953924 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 72.806604 MB/sec      write: 32.263796 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 59.526381 MB/sec      write: 34.981868 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 59.906832 MB/sec      write: 32.645118 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdc5)
  read: 58.260344 MB/sec      write: 26.106374 MB/sec
RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 78.143985 MB/sec      write: 39.318830 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 77.453834 MB/sec      write: 34.471592 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 77.828762 MB/sec      write: 32.166972 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 76.898167 MB/sec      write: 31.566999 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 73.809296 MB/sec      write: 34.251287 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 47.600543 MB/sec      write: 34.648886 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 54.200618 MB/sec      write: 31.072809 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=/dev/hdg5)
  read: 53.082003 MB/sec      write: 28.086779 MB/sec

With readahead of 256 blocks (on both /dev/hd? and /dev/md?):

RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 48.525528 MB/sec      write: 42.591060 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 47.474779 MB/sec      write: 39.262821 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 49.118508 MB/sec      write: 34.306099 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 49.764638 MB/sec      write: 35.755652 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 43.298362 MB/sec      write: 39.495906 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 41.074090 MB/sec      write: 33.199966 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 41.016373 MB/sec      write: 33.782837 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 39.634272 MB/sec      write: 30.377953 MB/sec

With readahead of 65536 blocks (on both /dev/hd? and /dev/md?):

RAID: --chunk=4 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 29.646205 MB/sec      write: 42.798913 MB/sec
RAID: --chunk=8 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 31.546354 MB/sec      write: 37.972348 MB/sec
RAID: --chunk=16 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 31.209560 MB/sec      write: 38.945801 MB/sec
RAID: --chunk=32 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 32.475593 MB/sec      write: 34.958779 MB/sec
RAID: --chunk=64 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 36.673161 MB/sec      write: 37.719941 MB/sec
RAID: --chunk=128 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 27.939899 MB/sec      write: 32.561181 MB/sec
RAID: --chunk=256 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 37.139007 MB/sec      write: 33.195663 MB/sec
RAID: --chunk=512 --level=5 -n3 /dev/hda5 /dev/hdc5 /dev/hdg5 (fail=)
  read: 49.537750 MB/sec      write: 28.594723 MB/sec


--------------060801000508090605060001--

