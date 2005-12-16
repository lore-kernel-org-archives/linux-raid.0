From: Carles Pina i Estany <carles@pinux.info>
Subject: LILO Error 09
Date: Fri, 16 Dec 2005 14:27:25 +0100
Message-ID: <20051216132725.GA5388@pinux.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I have two computers using RAID 1, with only one problem.

I am using hda and hdc, ReiserFS, Kernel 2.6.14.

I installed LILO on both hard disks, so I can disconnect primary master
and then BIOS tries to boot using hdc and it works fine.

When I was installing it I made some tests, and one time (with working
configuration) I just restarted and LILO wrote 09 09 09 09 09 (lot of
times, something like half screen). Then I restarted again and it worked
fine, and I had no more time to check it.

Today, after power failure and shutdown (UPC) system was not starting,
with this same problem.

In Manual.txt of Lilo I can read:
   
   0x09   "DMA attempt across 64k boundary". This shouldn't happen, but may 
       inicate a disk geometry mis-match. Try omitting the COMPACT option. You 
       may need to specify the disk geometry yourself.  

I never had this problem, and usually I works on Lilo. So I think
that maybe I have something in Lilo + RAID that is not fine. I don't
have "compact" option in LILO, and Lilo has not said to me any warning when
I installed it.

Any idea?

Thank you very much,

-- 
Carles Pina i Estany		GPG id: 0x8CBDAE64
	http://pinux.info	Manresa - Barcelona
