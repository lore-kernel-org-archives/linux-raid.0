From: Stephen C Woods <scw@seas.ucla.edu>
Subject: reconstrucion after a failed drive restarts on reboot
Date: Thu, 3 Apr 2003 08:11:32 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304031611.IAA13915@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

   After a drive has failed reconstruction restarts (this is the
expected result),  however if for some reason sthe system is rebooted
(even if mdadm --stop /dev/md0 has been done) reconstrcution restarts
from the begining.  Is there some way to have md save the last completed
point and pick up from there?

-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
