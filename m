From: Dieter Stueken <stueken@conterra.de>
Subject: Re: raid and sleeping bad sectors
Date: Tue, 29 Jun 2004 22:56:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E1D79A.5030405@conterra.de>
References: <200406291559.i5TFx6324611@watkins-home.com>	 <1088526607.13815.89.camel@localhost> <1088534585.5376.118.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1088534585.5376.118.camel@star2.austin.ibm.com>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mike Tran wrote:
> (Please note that I don't mean to advertise EVMS here :) just want to
> mention that the functionality is available)
> 
> EVMS, (http://evms.sourceforge.net) provides a solution to this "bad
> sectors" issue by having Bad Block Relocation (BBR) layer on the I/O
> stack.

Before proposing any solutions, i think it is very important to
distinguish carefully between different kinds of errors:

a) read errors: some alert bell should ring (syslog/mail..)
    but the system should not careless disable any disk to avoid
    making the problem even worse.

b) write errors: if some blocks are written partly, but can not
    be written to all disks, it may help, to write the data
    (may be temporary) somewhere else.

when we got a read error, due to an unreadable sector, we may
first try to rewrite it. In most cases, bad sector replacement
of the HD-firmware takes action and the problem is solved so far.

Only after this failed, we should turn over to plan b)

case b) may also help, if some disk gets temporary unavailable
(i.E. cabling problem). After manual intervention, that brings
the disk back on line again, the redirected data may even be
copied back.

Dieter
