From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RAID-5 creation crashes when files system installed while recovery going on
Date: Tue, 23 Jun 2009 15:35:08 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All,
 I started RAID-5 creation using mdadm command. While recovery is
happening I tried to install file system . I see intermittent crash   .
And crash doesn't happen at fixed location. Any clue what could be the
problem? How does the read/writes to MD driver handled while RAID-5 is
under building.
Thanks,
Marri
