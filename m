From: Boris Shingarov <shingarov@ca.istop.com>
Subject: All disks in the array suddenly non-fresh??
Date: Thu, 13 Oct 2005 21:07:55 -0400
Message-ID: <434F04EB.5070308@ca.istop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm very new to raid so my question is probably very basic.

This machine I have, is set up with three partitions on
three different disks (/dev/hda3, /dev/hde1, /dev/hdg1)
forming a raid-5 array, /dev/md0.
At some point, the machine became unresponsive, and on a reboot,
I get the following:

...
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
...
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md:  adding hda3 ...
md: created md0
md: bind<hda3>
md: bind<hde1>
md: bind<hdg1>
md: running: <hdg1><hde1><hda3>
md: kicking non-fresh hdg1 from array!
md: unbind<hdg1>
md: export_rdev(hdg1)
md: kicking non-fresh hde1 from array!
md: unbind<hde1>
md: export_rdev(hde1)
md: personality 4 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hda3>
md: export_rdev(hda3)
md: ... autorun DONE.

I am using classic (non-mdadm) raid tools.  Of course everything
like /proc/mdstat, shows I have no md0, nor can I start md0.
What would be the next logical thing to investigate, to get out
of this situation?

Boris

