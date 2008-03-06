From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: RAID-5 data corruption
Date: Wed, 5 Mar 2008 18:11:17 -0700
Message-ID: <e9c3a7c20803051711y56500b89n3c3c9984d4607b9b@mail.gmail.com>
References: <47CF2B62.7070806@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CF2B62.7070806@student.tuwien.ac.at>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 5, 2008 at 4:23 PM, Oliver Martin
<oliver.martin@student.tuwien.ac.at> wrote:
>  I'll see if I can recover my data, but do you have any ideas what caused
>  the problem in the first place?
>

Did one of the disks cause the USB reset message?  It appears to
coincide with the start of the trouble, but it may be just that,
coincidence.

Mar  2 01:06:02 quassel kernel: md: using 128k window, over a total of
488383936 blocks.
Mar  2 09:03:43 quassel kernel: usb 4-5.3.2: reset high speed USB
device using ehci_hcd and address 8
Mar  2 09:25:15 quassel kernel: EXT3-fs error (device dm-0):
htree_dirblock_to_tree: bad entry in directory #57262081: directory
entry across blocks - offset=0, inode=2917738116, rec_len=11736,
name_len=107
Mar  2 10:30:46 quassel kernel: md: md0: data-check done.

The output of something like 'ls -l /sys/block/sdb/device' should tell.

Have you run this operation on a kernel version prior to 2.6.24.3? If
so, which version?

--
Dan
