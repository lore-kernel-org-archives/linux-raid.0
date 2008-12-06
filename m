From: "David Lethe" <david@santools.com>
Subject: RE: Need urgent help in fixing raid5 array
Date: Fri, 5 Dec 2008 18:52:33 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C02E88F49@34093-C3-EVS3.exchange.rackspace.com>
References: <936691.74609.qm@web30806.mail.mud.yahoo.com> <447802.83994.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0812051922530.4906@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0812051922530.4906@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Justin Piszcz
> Sent: Friday, December 05, 2008 6:25 PM

Mike - Really strongly consider bringing in a pro, or at very least,
buying some scratch disks so you can work with copies.  Forced assembly
doesn't look at the data if you are degraded, so it has high potential
to make things worse.  Too many things going on here ... If data is
backed up and you just want to save some time with an experiment ...
then go forward with assume-clean.  

But it will likely destroy a large chunk of your data in the process,
destroy it forever.  

David


