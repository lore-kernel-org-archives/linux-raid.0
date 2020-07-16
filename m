From: Ian Pilcher <arequipeno@gmail.com>
Subject: Programmatically check "global" RAID state?
Date: Thu, 16 Jul 2020 08:38:32 -0500
Message-ID: <repl8o$ggb$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to write a quick script/program for my NAS that will initiate a
check of one of my RAID devices every night.  However, I want it to skip
the check if either of the following is true:

* Another check/resync is in process on any RAID device, or

* Any of the RAID devices on the system are unhealthy (degraded or
   failed).

Is there any way to programmatically check the "global" status of the
RAID subsystem like this, or am I stuck iterating through all of the
devices (likely via sysfs) and checking them individually?  (I'm pretty
sure that I am "stuck" but wanted to check just in case.)

Thanks!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
