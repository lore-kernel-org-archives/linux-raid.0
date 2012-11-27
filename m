From: Joe Landman <joe.landman@gmail.com>
Subject: is there a known issue with MD in the 3.6.6 kernel, where it keeps
 breaking software raids?
Date: Tue, 27 Nov 2012 17:15:40 -0500
Message-ID: <50B53B8C.8020807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings Neil and rest of raid-world

   I am noticing a pattern with 3.6.6 whereby software RAIDs (RAID10, 
RAID10, and RAID6) "fail" after a reboot, and we have to force both 
correct RAID assembly, and let the drives finish rebuilding.

   I am not sure if this is a kernel issue, an MD issue, or something 
else.  It is happening across several different HBAs (LSI and Intel) on 
the same unit.  We could try updating to 3.6.8.  Is there a known issue 
with RAID shutdown or device shutdown in that kernel that does this? 
The 3.2.x series didn't do this.  Nor did the 3.5.x series.

   Thanks!

   Joe

