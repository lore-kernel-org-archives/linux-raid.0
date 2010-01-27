From: Rick Bragg <lists@gmnet.net>
Subject: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 09:03:44 -0500
Message-ID: <1264601024.29409.19.camel@thor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a system with raid10 running Ubuntu 8.10.  It uses a
"promise"card

# lsusb
..
01:02.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
300 TX4) (rev 02)
..

I have 4 identical disks on it and they show up as /dev/sda, b, c, and
d.

However, sdb needs to be replaced.  How can I tell which drive is sdb?
Is there a way to identify what drive is what?

Thanks
Rick





