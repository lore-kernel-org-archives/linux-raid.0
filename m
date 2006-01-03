From: John Rowe <rowe@excc.ex.ac.uk>
Subject: RAID 5 recovery?
Date: Tue, 03 Jan 2006 15:24:28 +0000
Message-ID: <1136301868.2785.23.camel@dogbert>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Due to an extended power outage over the new year, I have a RAID5 array
with two dirty devices so it won't come up. The HOWTO suggests running:

 mdadm --assemble --force

Is this good advice? I'm running RedHat 9 so I don't have mdadm but of
course I'm happy to install it.

Thanks

John


