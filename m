From: Markus Gehring <markus.gehring@infinia.de>
Subject: RAID1 Corruption
Date: Mon, 17 Jan 2005 19:26:57 +0100
Message-ID: <41EC0371.9060106@infinia.de>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net> <200501171704.10374.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501171704.10374.andrew@walrond.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: anders@anduras.de, nicoya@ubb.ca
List-Id: linux-raid.ids

Hi Folks!

I have a reproducable problem with corrupted data read from a RAID1-array.

Setup:
  HW:
   2 S-ATA-Disks (160GB each) -> /dev/md4 RAID1
   Promise S150 TX4 - Controller
   AMD Sempron 2200+

  SW:
   Fedora Core 3
   Kernel 2.6.10 unpatched
   Samba (for read/write-accesses)
   SW-Raid

Everything works fine with only one drive in the array. If the second is
synced up read accesses return corrupted data.

Interesting: If you remove again the second disk. The same files will be
  read correctly again (no matter if written while only one disk is in
the array or two are synced!)!

Tests with differend disks (2x80GB Seagate and 2x160GB Samsung),
different partition sizes (20, 40, 80, 160GB), different filesytems
(ext3, ext2, reiser) showed the same results.

If i use the drive without raid everything works fine.

Many Thanks in advance!

Best regards,
  Markus

