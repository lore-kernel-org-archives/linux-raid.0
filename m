From: "Koen De Jaeger" <hunter15847@hotmail.com>
Subject: mdadm multipath poweredge qlogic emc -> howto use failover
Date: Mon, 19 Jul 2004 10:37:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BAY14-F30FTXY6zN80X000bf14e@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wanted to know if there is a free solution available for the following 
problem:

Our dell poweredge 2650 uses two qlogic fiberoptic channels to connect to 
emc storage on gentoo linux. (sdb and sdc)

Since only sdc is active (sdb only works when sdc fails); the kernel only 
initialises sdc on boot time.

Now when I make a multipath with mdadm for sdb and sdb, and sdc fails. Then 
it tries to connect to sdb but this doesn't work because for the kernel sdb 
was not ready.

What do I have to do to make this work?

_________________________________________________________________
Plannen om een nieuwe computer te kopen? Kijk eens hier.. 
http://www.msn.be/shopping/dell_bis/

