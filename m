From: Paul Waldo <pwaldo@waldoware.com>
Subject: Kernel panic during resync
Date: Fri, 11 Aug 2006 09:08:35 -0400
Message-ID: <44DC8153.8010105@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've got a machine with a RAID6 array which hung on me yesterday.  Upon
reboot, mdadm refused to start the array, since it was degraded and
dirty.  The array had 7 drives, and one had previously gone bad.  I'm
running Fedora Core 5.

I rebooted, using the "md-mod.start_dirty_degraded=1" parameter.
Everything seemed to be OK--the sync process started and I watched it go
for about half an hour.  I came back later, and found the machine had a
kernel panic with the message "Kernel panic - not syncing: Fatal
exception in interrupt".  Just to make sure, I restarted and tried to
sync again, but got the same message.

What might be causing this?  Is there any way to recover?  Thanks in
advance!

Paul

