From: "Stephan Kessler" <root@warpy.yomeganet.biz>
Subject: Strange behavior: Badblocks go away ;)
Date: Thu, 19 Feb 2004 06:39:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c3f6aa$c94632c0$4db0fea9@kessler.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Corresponding to that:
http://marc.theaimsgroup.com/?l=linux-raid&m=107684467010898&w=2

I have had some badblocks and wanted to fix them. The only real Problem
was if an 

"e2fsck -f -n -l bblist /dev/md0"

On a mounted RAID Device will make damage to a file system. If anyone
knows an answer to this, i would be real happy :)

Anyways why i open a new thread:
Yesterday the PowerSupply in the computercenter, where my server stands,
was broken and my server was unwillingly rebooted. Because it was a
power failure, the raid had to resync. After that i took a look in the
syslog (kern.log), and there wasn't any hint on badblocks (like an
uncorrectable error on /dev/hda1 etc.) So it seems that the badblocks
went away....

I'm happy but i still want to know where they are, and if they come back
;)

Any hint is useful! :D

Greetings,
Stephan

