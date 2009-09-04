From: lfmarante@free.fr
Subject: Software Raid 5 work on ROOT ?
Date: Fri, 04 Sep 2009 12:19:23 +0200
Message-ID: <1252059563.4aa0e9ab25de3@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello every body.

I have a question in regard of booting linux under a raid 5. It is possible ?
All the guides that I found on the net say to have a /boot not stripped, (raid1
is ok). [EX: http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
]

They say to have / not stripped too. And these guide show to have an raid 1 boot
and / and create a LVM volume for /usr /opt /var /whatever that can be raid 5.
It is not easiest to have directly / in raid 5 format ?
If it's possible I would prefere to have raid 5 /
There any particular configuration for grub to boot it?

Thanks in advance.

