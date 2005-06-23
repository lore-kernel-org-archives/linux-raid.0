From: bdameron@pivotlink.com
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 17:20:33 -0700
Message-ID: <1119486033.42ba005107e3b@mail.pivotlink.com>
References: <5d96567b05061804477325d743@mail.gmail.com>     <200506221316.33178.hjm@tacgi.com>     <1119474566.11039.12.camel@dhcpc226.office.pivotlink.com>     <200506221443.28613.hjm@tacgi.com>    <1119477636.5501.161.camel@localhost.localdomain> <59502.10.0.15.208.1119478297.squirrel@postal2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59502.10.0.15.208.1119478297.squirrel@postal2>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is no U320 SCSI bus. This is a SATA card. Each drive has it's own 
150MBps port. The PCI-X speed of course limits it to 1.06GB per second. I 
doubt the drives will come close to that.

Brad Dameron
SeaTab Software
www.seatab.com


Quoting John Madden <jmadden@ivytech.edu>:

> > will this 24 port card itself will be a bottleneck?
> 
> Yes.  The U320 SCSI bus on which it resides will be if nothing else.
> 
> John
> 
