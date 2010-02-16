From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Auto Checking Raid 6 crashes my system
Date: Mon, 15 Feb 2010 21:04:07 -0800
Message-ID: <adf93d751002152104w52b329fdx9eb54719f1c8587a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just build a brand new md raid-6 with 5 disks.  And on Fedora 12,
the auto checking of md devices via a weekly cron job is enabled by
default.  It performs the checking by echo "check" into
/sys/block/mdX/md/sync_action.  But after a while, the kernel just
crashes, without finishing checking the raid device or leaving
anything in the messages file.

For now, I've disable the raid-check cron job.  The kernel version I'm
running is 2.6.31.12-174.2.3.fc12.x86_64.

Thanks,

DS
