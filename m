From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 11:49:04 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E1373776451180F06E4@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: "C. R. Oldham" <cro@ncacasi.org>, Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

According to sar and Orca, over the past 4 months the box is about 95%
idle most of the time so I don't think CPU load will be an issue.  The
box is a quad Xeon 1.4GHz with 8GB RAM.

-----Original Message-----
From: C. R. Oldham [mailto:cro@ncacasi.org] 
Sent: Friday, February 21, 2003 11:35 AM
To: Rechenberg, Andrew; Mike Dresser
Cc: linux-raid@vger.kernel.org
Subject: RE: Questions about VERY large software raid config


> I have test hardware with 20 drives and it appears to behave
> nicely and I'm getting much better throughput from software
> RAID than the Dell PERC hardware

Have you tracked your CPU load?  That is one thing that has kept me from
going back to software RAID.


-- 
C. R. Oldham
Director of Technology
NCA CASI
