From: Corey McGuire <coreyfro@coreyfro.com>
Subject: Read-Balancing
Date: Sat, 31 Jan 2004 17:47:23 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401311747.23263.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey folks,

Quick question.

I have been reading up on read-balancing, and I understand that 2.6 has been tuned to have the drive head closest to the data perform the read to reduce seak times. This is neat, but can it prevent two disks from working together to read the same, nonfragmented file?  Did read-balancing ever allow the ability for mirrored drives to work together on a sequential read?  Seams that in a large read, each drive in a mirror could pick up a piece to read, and then reassembled the sequential read in RAM.

Also, does this prevent balancing multiple separate reads in the same file, or will the idle disk seak and read while the drive closer to the action is busy?  Assuming, of course, the data isn't in cache.

Just therory stuff, really, but a curiosity none the less.

