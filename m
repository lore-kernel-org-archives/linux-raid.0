From: Rik Herrin <rikherrin@yahoo.com>
Subject: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 02:07:03 -0800 (PST)
Message-ID: <20051222100703.23157.qmail@web52909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
	I was interested in Linux's RAID capabilities and
read that mdadm was the tool of choice.  We are
currently comparing software RAID with hardware RAID
and to complete our comparison, we were wondering if
the following is supported by mdadm:

	1) OCE: Online Capacity Expansion:  From the latest
version of mdadm (v2.2), it ssems that there is
support for it with the -G option.  How well tested is
this?  Also, in the Readme / Man page, it mentions:
		This usage causes mdadm to attempt to reconfigure a
running array.  This is only possibly if the kernel
being used supports a particular reconfiguration.
	How can I know if the kernel I am using supports this
reconfiguration?  What if I'm compiling the kernel by
hand.  What options would I have to enable?
	2) RAID Level Migration:  Does mdadm currently
support this feature?
	3) Performance issues:  I'm currently thinking of
using either RAID 10 or LVM2 with RAID 5 to serve as a
RAID server.  The machine will be running either an
AMD 64 processor or a dual-core AMD 64 processor, so I
don't think the CPU will be a bottleneck.  In fact, it
should easily pass the speed of most "hardware" based
RAID systems.
	4) Would anyone recommend a certain hotswap
enclosure?
	5) Finally, I'm thinking of integrating this in a
custom SAN backend.  Anyone try this before?  Thanks
for your time.

PS.  Some of the terms used in the man page are a bit
ambiguous.  For example, what does --write-mostly
refer to?  Thanks for your time.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
