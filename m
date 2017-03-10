From: Alfred Matthews <asm13243546@gmail.com>
Subject: on assembly and recovery of a hardware RAID
Date: Fri, 10 Mar 2017 15:37:48 -0500
Message-ID: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list. I'm facing a non-redundant Western Digital hardware RAID,
for which, hardware seems to cause a kernel panic at about 3 seconds
running time.

I've assembled the customary testing. The drives appear to be striped RAID 0.

Output: http://pastebin.com/c361jGVx

Evidently WD metadata changes over time, since a new console (adding
USB) will not recognize the drives without erasing them. Files are
visible as files for the short period of controller health.

I imagine I'm trying to assemble a 2 x 3TB RAID array from the
original WD disks when mounted as SATA.

Seeking input on proper mdadm configuration for this.

Then I imagine that I may recover files-as-files from this 2 x 3TB to
standalone disks. Ultimately they would need to move to a new RAID.

Failing: WD My Book Thunderbolt Duo, 2x3TB
New, incompatible: WD My Book Pro, 2x3TB.

Thanks for any comment.

Thanks for your time.

Al Matthews
