From: Nat Makarevitch <Shelso@makarevitch.org>
Subject: Determining which spindle is out of order
Date: Wed, 3 Nov 2010 14:13:25 +0000 (UTC)
Message-ID: <loom.20101103T115828-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

After a spindle (physical hard disk, a "drive") failure in a "md" RAID array,
how can we know which spindle must be replaced?

We want to avoid extracting a working spindle by mistakenly thinking it is the
faulty one...

To solve this problem we put on each spindle a physical label (a tag, not a
partition/disk label) showing its device name (sda, sdb...).

To do so: on an otherwise unused system and sane RAID array we ran "dd" for each
each spindle (individual device) in order to read on it, lighting up its LED.

Then we simulated a crash by physically removing two spindles. Upon reboot the
devices names changed (?!) and our labels weren't right anymore albeit we are
pretty sure they were.

Context: raid10, 10 spindles (8 active + 2 spare), layout : near=1, offset=3. On
the integrated controller + a LSI MPT on-board controller.

