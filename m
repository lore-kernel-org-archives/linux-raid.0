From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: Question on RAID-5 growing
Date: Thu, 23 Jul 2009 23:45:28 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7CDEB@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is it legal to grow while RAID-5 recovery Is happening ?


1. mdadm -C /dev/md0 -z 1000000 -l 5 -n 3 /dev/sd[a-c]
2. mdadm -a /dev/md0 /dev/sdd
3. mdadm -G /dev/md- -n 4


--Marri
