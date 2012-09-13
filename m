From: Daniel Frey <djqfrey@gmail.com>
Subject: Stop IMSM verify?
Date: Wed, 12 Sep 2012 18:00:21 -0700
Message-ID: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any way to stop the verify of an IMSM raid through mdadm?

I found https://raid.wiki.kernel.org/index.php/RAID_Administration,
but the imsm raid does not seem to have sync_action anywhere in the
/sys/block tree.

I've been having issues with suspend which I'm trying to troubleshoot,
and I know I can stop it if I boot into Windows. Just wondering if
that functionality is in mdadm.

Dan
