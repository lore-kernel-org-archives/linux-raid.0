From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Problem with RAID5 and USB2 using 2.4.27
Date: Fri, 10 Dec 2004 06:02:00 -0600
Message-ID: <6d5bedd804121004026c153b59@mail.gmail.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Have a 4-disk RAID 5 array of 250Gig HDs that I am looking to use for
performing video capture and editing. Two of the disks are internal,
and two are external and connected using a USB2 card. Running under a
Debian installation with a 2.4.27 kernel, I can capture for a few
minutes, but then I start to drop frames, and the percentage dropped
gets worse as time goes on.

Would going to a 2.6 kernel where I gather there are some additional
features available "fix" this, or do I need to look at moving to
firewire or something else? I'm reticent to move to firewire as I was
having troubles with my system "forgetting" that it could talk to some
of the disks after a reboot, but if I have to then I guess I have to
:-)

Thanks,
Ewan
