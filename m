From: wiebittewas <wiebittewas@googlemail.com>
Subject: powersaving of disks fails with activated raid...
Date: Wed, 16 Jun 2010 11:36:53 +0000
Message-ID: <4C18B755.1080606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

after I used a while single disks for storage and had no problems to
suspend idle disks to save power-consumption, I switched soon to use
raid5, but even the fs on it is not mounted and no md-monitoring in
user-space is active, suspending fails due to activity on the disks
below the raid5.

it seems, that the kthread of the raid is working on the disks even,
there's no user-activity at all.

so my questions:

- what is the md-kthread doing there?
- is there any possibilty to prevent this behaviour?

if nobody knows an answer to that, maybe to this:

- is there a possibilty, how I can trace the raw disk-io of the
sata-devices to see what is happening?


wiebittewas
