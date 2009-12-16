From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RAID-5 degraded mode question
Date: Wed, 16 Dec 2009 12:20:04 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com>
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
  I have question on degraded mode RAID-5 operation md driver. If I
understand reads from the degraded mode md would cause  parity
calculations or rebuild of  data happens for every request. 

 Also as soon as disk failed md drivers marks that drive as faulty and
continue operation in degraded mode right ? Is there a way to get out
the degraded mode without adding spare drive. Assuming we have 5 disk
system with one failed drive.

Thanks in advance,
Marri
