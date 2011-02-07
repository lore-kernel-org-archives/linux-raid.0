From: Henrik Olsson <henrik@fixme.se>
Subject: Mixing 512 bytes and 4K sector harddrives in a raid1?
Date: Mon, 7 Feb 2011 12:41:13 +0100
Message-ID: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

One of the drives in my raid1 recently crashed and it looks like all
the replacement disks (2TB) i can find use 4K sectors, but the old
ones were 512 bytes.
Are there any issues with having a raid1 array with different sector
sizes for the drives?

Regards,
Henrik
