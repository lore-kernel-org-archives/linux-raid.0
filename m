From: Roe Peterson <roe@liveglobalbid.com>
Subject: 2.5.27 RAID1 not shutting down at halt/reboot???
Date: Tue, 23 Jul 2002 10:42:16 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <30831.128350883$1027443128@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Linux 2.5.27 running over a redhat 7.3 distro...

I've got the raid1/md stuff working correctly, but the system doesn't
shut
down the raid arrays at reboot/halt/poweroff...

A quick look at the md_notify_reboot code in drivers/md.c line 3174
reveals:

    printk(KERN_INFO "md: stopping all md devices.\n");
    return NOTIFY_DONE;

!!! followed by the md array shutdown code, which is obviously never
called.

Is there a reason for this?  Should _something_else_ be shutting down
/read-only switching the raid arrays at system halt?



