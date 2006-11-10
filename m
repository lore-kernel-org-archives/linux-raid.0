From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[2]: RAID1 submirror failure causes reboot?
Date: Fri, 10 Nov 2006 15:53:06 +0300
Message-ID: <208777171.20061110155306@2ka.mipt.ru>
References: <1007879814.20061110111729@2ka.mipt.ru>
 <17748.15156.405065.904318@cse.unsw.edu.au>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17748.15156.405065.904318@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

>> [87398.531579] blk: request botched
NB>                  ^^^^^^^^^^^^^^^^^^^^

NB> That looks bad.  Possible some bug in the IDE controller or elsewhere
NB> in the block layer.  Jens: What might cause that?

NB> --snip--

NB> That doesn't look like raid was involved.  If it was you would expect
NB> to see raid1_end_write_request or raid1_end_read_request in that
NB> trace.
So that might be the hard or soft part of IDE layer failing the
system, or a PCI problem for example?

Just in case, motherboard is Supermicro X5DPE-G2: e7501 chipset,
Dual Xeon-533. Rather old now, way cool back when it was bought ;)
But, as anything new, it could be manufactured bad. Maybe now there
are some well-known problems with the tech?

NB> Do you have any other partitions of hdc in use but not on raid?
NB> Which partition is sector 176315718 in ??
All partitions are mirrored, and this sector is in hdc11:

# fdisk /dev/hdc
...
Command (m for help): u
Changing display/entry units to sectors

Command (m for help): p

Disk /dev/hdc: 102.9 GB, 102935347200 bytes
16 heads, 63 sectors/track, 199450 cylinders, total 201045600 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1   *          63     1000943      500440+  fd  Linux raid autodetect
/dev/hdc2         1000944     5001695     2000376   fd  Linux raid autodetect
/dev/hdc3         5001696    16721711     5860008   83  Linux
/dev/hdc4        16721712   201045599    92161944    5  Extended
/dev/hdc5        16721775    24534719     3906472+  83  Linux
/dev/hdc6        24534783    28441727     1953472+  83  Linux
/dev/hdc7        28441791    32348735     1953472+  83  Linux
/dev/hdc8        32348799    44068751     5859976+  83  Linux
/dev/hdc9        44068815    51881759     3906472+  83  Linux
/dev/hdc10       51881823    59694767     3906472+  83  Linux
/dev/hdc11       59694831   190555343    65430256+  83  Linux
/dev/hdc12      190555407   201045599     5245096+  83  Linux


-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

