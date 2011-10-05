From: "Guy Watkins" <Guy@watkins-home.com>
Subject: Does Linux support Intel Smart Response Technology?
Date: Tue, 04 Oct 2011 23:04:55 -0400
Message-ID: <08c701cc830b$91ed7900$b5c86b00$@Watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know this is not the correct place to ask, but I hope someone here will
know.

Does Linux support the Intel Smart Response Technology?

I am building a new computer and will have two 2TB disks and a 64 or 120 GB
SSD.  I am hoping to use the SSD cache feature.  I think I would configure a
bios RAID with 1 disk and the SSD as a cache, then use Linux to mirror that
with the second 2TB disk using the write mostly feature of MD.  But would it
be better to create a bios RAID1 with both disks and the ssd cache?

If I can't use that feature, does anyone have any tips on using two 2TB
disks and 1 SSD?  The best I can figure is to create a 3 way mirror using
all disks and set the hard disks to write mostly, and putting the OS and
/home on the 3 way mirror(s) then a 2 way mirror with the remaining space
for non-OS stuff (home movies, pictures, iso, whatever).

Thanks for any help,
Guy

