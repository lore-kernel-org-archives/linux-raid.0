From: Technomage <technomage-hawke@cox.net>
Subject: recovering data on a failed raid-0 installation
Date: Mon, 27 Mar 2006 16:35:47 -0700
Message-ID: <200603271635.48466.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok,
here's the situation in a nutshell.

one of the 2 HD's in a linux raid-0 installation has failed.

Fortunately, or otherwise, it was NOT the primary HD.

problem is, I need to recover data from the first drive but appear to be 
unable to do so because the raid is not complete. the second drive only had 
193 MB written to it and I am fairly certain that the data I would like to 
recover is NOT on that drive.

can anyone offer any solutions to this?

the second HD is not usable (heat related failure issues). 

The filesystem used on the md0 partition (under mdadm) was xfs. now I have 
tried the xfs_check and xfs_repair tools and they are not helpful at this 
point.

The developer (of mdadm) suggested I use the following commands in an attempt 
to recover:

  mdadm -C /dev/md0 -l0 -n2 /dev/......
  fsck -n /dev/md0

However, the second one was a no go.

I am stumped as to how to proceed here. I need the data off the first drive, 
but do not appear to have any way (other than using cat to see it) to get at 
it.

some help would be greatly appreciated.

technomage
