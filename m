From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Single md physical device limit
Date: Mon, 19 Aug 2002 14:46:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CDF05CB9FCA0C845B9778F9E463C476101FC5F@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Without drastically modifying the kernel code, is there any way to
increase the physical device limit when building a single md device?  I
believe that the currently limit is 12 physical disks (?)

For reference, I would like to stripe across an entire Dell PowerVault
220S, which has 14 drives in it.

Thanks in advance,
Andy.

Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
arechenberg (at) shermanfinancialgroup.com

