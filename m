From: "kyle" <kylewong@southa.com>
Subject: questions about ext3, raid-5, small files and wasted disk space
Date: Sat, 12 Nov 2005 04:32:27 +0800
Message-ID: <000901c5e6ff$0865deb0$b7df0f3d@kyleont8n3poyo>
Reply-To: "kyle" <kylewong@southa.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Assume I want to build a 8 x 250GB disks RAID-5, totally around 1.7TB, with
ext3 file system, 4KB block size, and 32KB chunk size.

Almost half of the files will be very small ( < 8KB), I'm quite confused
with how RAID-5 store data so I want to understand how relation between file
system block size and RAID5 chunk size, to minimize possible wasted space.

I understand that if I store a 224KB file into the RAID5, the file will be
divided into 7 parts x 32KB, plus 32KB parity. (Am I correct in this?)

However, If I store a file smaller than chunk size into the RAID5, what will
happen?  For example, If  I store a 1KB file into it, how much disk space
will be used? will it 4KB (plus 4KB parity or 1KB parity) ?

Similiarly, If I store a 6KB file, will it takes 8KB (plus 8KB parity or 6KB
parity) ?

If  ALL of my files are 6KB, will the physical disk space allocated to
parity NOT ENOUGH to serve the whole filesystem?

Please CC me if possible, thanks.

Kyle



