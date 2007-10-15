From: "Jeffrey B. Layton" <laytonjb@charter.net>
Subject: How to determine drive order in RAID-1
Date: Mon, 15 Oct 2007 19:44:07 -0400
Message-ID: <4713FB47.1010507@charter.net>
Reply-To: laytonjb@charter.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good evening,

I hate to be a noob, but my system is dying (I think it's a bad
motherboard) so I wanted to get this email out before the system
died again.

I've got 2 different RAID-1 devices (md0 and md1). md0 uses
the on-board IDE controller and md1 has two SATA drives
each is attached to a Promise SATA300 TX2 controller
(one drive to one controller). Is there anyway to determine
which drive is the first drive in the md device and which is
the second.

The reason I want to determine this is that I will be moving
the drives to a new system. Or does it matter in which order
they are moved? (the OS drive is moving over as well).

Thanks!

Jeff

