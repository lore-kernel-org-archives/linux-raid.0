From: Ming Zhang <mingz@ele.uri.edu>
Subject: raid 1 with write only device?
Date: Thu, 04 Nov 2004 22:12:13 -0500
Message-ID: <1099624332.3131.104.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, folks?

I would like to know if current RAID1 support or willing to support a
RAID1 with a write only device? For example, u can setup 2 disks to form
a raid1, you fork 2 writes to both disks while you only read from one.
this will be very useful for logging purpose or replication.


Ming


