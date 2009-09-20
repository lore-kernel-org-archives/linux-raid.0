From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: CPU util with and without Raid5
Date: Sun, 20 Sep 2009 02:09:25 -0700
Message-ID: <f5d1f90a0909200209h78103cf2s237b69b946297125@mail.gmail.com>
References: <f5d1f90a0909181713x3cb99143raa9e64c27ccac999@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909181713x3cb99143raa9e64c27ccac999@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

I'm seeing some strangeness and want some insight.

Case #1:
I have 5 disks on my system and each is exported to a iSCSI initiator.
When I run IOMeter tool, I see CPU util of about 80% of my CPU for
Seq-Read operations.

Case #2:
If I bundle these 5 disks as Raid5, the performance is 20% lower as
compared to above case but the CPU util is only 30% for Seq Read
operations (as compared to 80% in case #1)

Can someone shed some light on this - why would CPU be lower in #2
(I'm using 2.6.27 kernel in both cases)?

Thanks!
