From: Jeremy Huddleston <jeremyhu@uclink4.berkeley.edu>
Subject: array degraded after reboot
Date: Thu, 01 May 2003 20:59:55 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB1ED3B.4060304@uclink4.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080903060404080609020302"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080903060404080609020302
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I wanted to remove /dev/hdk6 from my array and replace it with a new 
drive at /dev/hdj6 (I know about the efficiency problems involved with 
this, but trust me that this is what I want to do for some other 
reasons), so I did the following:

mdadm -f /dev/md6 /dev/hdk6
mdadm -r /dev/md6 /dev/hdk6
mdadm -a /dev/md6 /dev/hdj6

The RAID reonsctucted itself, and it was working fine, so I rebooted the 
machine and removed the /dev/hdk hard drive from my computer.  When 
linux started up again, I checked /proc/mdstat, and it said that the 
RAID was running in degraded mode without /dev/hdj6.

I did the process again and stored information at each step (you can see 
this in the tarball).

I am using mdadm 1.2.0.

Thanks for the help.

--jeremy

--------------080903060404080609020302
Content-Type: application/x-gzip;
 name="mdebug.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mdebug.tar.gz"

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
--------------080903060404080609020302--

