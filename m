From: "Clayton Bell" <Clayton.Bell@coles.com.au>
Subject: md raid1 in active-active arrangement
Date: Fri, 4 Jan 2008 11:20:55 +1100
Message-ID: <49DFE57FB126044B8A8B934E7AEA09ED0A456A94@WPEXCH05.colesmyer.ad.cmltd.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is it reasonable for a raid1 mirror to be momentarily active on two servers at the same time?

This question has come about from Xen virtual host live migrations.


Consider the case with shared storage between two servers:

Server A: /dev/md0 is raid1 to devices /dev/mapper/wwidX and /dev/mapper/wwidY
Server B: /dev/md0 is raid1 to devices /dev/mapper/wwidX and /dev/mapper/wwidY

/dev/md0 is assigned to the Xen virtual host (ie it becomes /dev/sda within the virtual host)


When live migrating the virtual host from Server A to Server B, /dev/md0 must be active on both server A and B at the same time, at least momentarily.

Is md going to cope with this kind of setup?  Under what conditions will it fail dismally?

To me it would seem as though the migration can only occur when:
1. the mirrors are in sync
2. Server A and B use their own/separate external bitmap file for /dev/md0

Even if the time duration that both /dev/md0's are active is minimized to less than a second, what possible data corruption could occur?


Feedback much appreciated.  I hope the linux-raid group finds this situation least a little interesting.

Thank you

Clayton

This email and any attachments may contain privileged and confidential information and are intended for the named addressee only. If you have received this e-mail in error, please notify the sender and delete this e-mail immediately. Any confidentiality, privilege or copyright is not waived or lost because this e-mail has been sent to you in error. It is your responsibility to check this e-mail and any attachments for viruses.  No warranty is made that this material is free from computer virus or any other defect or error.  Any loss/damage incurred by using this material is not the sender's responsibility.  The sender's entire liability will be limited to resupplying the material.
