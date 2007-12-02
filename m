From: Neil Brown <neilb@suse.de>
Subject: Re: Spontaneous rebuild
Date: Mon, 3 Dec 2007 10:14:37 +1100
Message-ID: <18259.15453.811495.461016@notabene.brown>
References: <475230AF.3010100@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Oliver Martin on Sunday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 2, oliver.martin@student.tuwien.ac.at wrote:
> 
> Anyway, the problems are back: To test my theory that everything is
> alright with the CPU running within its specs, I removed one of the
> drives while copying some large files yesterday. Initially, everything
> seemed to work out nicely, and by the morning, the rebuild had finished.
> Again, I unmounted the filesystem and ran badblocks -svn on the LVM. It
> ran without gripes for some hours, but just now I saw md had started to
> rebuild the array again out of the blue:
> 
> Dec  1 20:04:49 quassel kernel: usb 4-5.2: reset high speed USB device
> using ehci_hcd and address 4
> Dec  2 01:06:02 quassel kernel: md: data-check of RAID array md0
                                      ^^^^^^^^^^
> Dec  2 01:06:02 quassel kernel: md: minimum _guaranteed_  speed: 1000
> KB/sec/disk.
> Dec  2 01:06:02 quassel kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for data-check.
                                                  ^^^^^^^^^^
> Dec  2 01:06:02 quassel kernel: md: using 128k window, over a total of
> 488383936 blocks.
> Dec  2 03:57:24 quassel kernel: usb 4-5.2: reset high speed USB device
> using ehci_hcd and address 4
> 

This isn't a resync, it is a data check.  "Dec  2" is the first Sunday
of the month.  You probably have a crontab entries that does
   echo check > /sys/block/mdX/md/sync_action

early on the first Sunday of the month.  I know that Debian does this.

It is good to do this occasionally to catch sleeping bad blocks.

NeilBrown
