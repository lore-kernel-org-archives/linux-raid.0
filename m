From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: RAID 0 -> 1 possible?
Date: Fri, 12 Mar 2004 10:28:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4051D738.309CB8FE@SteelEye.com>
References: <4050CF9C.6000704@microcenter.com> <4051503E.6090703@tequila.co.jp> <4051CCBF.2020108@microcenter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jeff Hoffmann <jhoffman@microelectronics.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Hoffmann wrote:

> > | Convert / from RAID 0 to 1 without requiring a backup/reinstall/restore
> > | scenario

> Indeed.  In my case, the data actually on the partition is < 25%. 

Well, in that case you just might be able to do it. You'll need to
shrink your filesystem (if you have one) ala resize2fs or similar. Then
raidreconf the raid0. Then edit the partition table (there are tools to
help with this, or just use fdisk very carefully) to shrink the
partition. Then you can create a new partition and dump the data there.
Create another similarly sized partition and raid1 them together...

It's certainly possible...but it's starting to sound like a
backup/restore might be easier than all that (you probably want to
backup before doing these types of things anyway, if you care about the
data).

--
Paul
