From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: RAID-6 support in kernel?
Date: Mon, 3 Jun 2002 01:01:23 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206030044270.27651-100000@mail.pronto.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

hi all

I'n working on server setup with some 16 disks in RAID-5; one of them a 
spare. After a little reading, I find myself longing for support for 
RAID-6 support in kernel, giving the opportunity to allow for two failed 
drives without a chrash (see links about RAID-6 below if interested).

I am aware of that not all kernel hackers like such configurations, and
that some will rather see small RAID-configurations connected with VLM.  
I beleive there is a reason for using RAID-6, and RAID-controller vendors
(such as Compaq) are already using them, so why shouldn't linux do so
also? With a high number of cheap IDE drives, the chance of one failing is 
quite high, so why not RAID-6? At least for a system doing most reads...

thanks

roy

RAID-6 layout: http://www.acnc.com/04_01_06.html

-- 
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.

