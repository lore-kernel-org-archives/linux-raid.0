From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Software RAID5, promise IDE and system freeze...
Date: Mon, 30 Aug 2004 13:15:12 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4132F020.1020801@wasp.net.au>
References: <4132E76F.7090209@cg.cs.tu-bs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4132E76F.7090209@cg.cs.tu-bs.de>
To: Lars Schimmer <schimmer@cg.cs.tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Schimmer wrote:

> When building a raid with the 3 HDs on MoBo & SATA and 2 HDs of ONE of
> these 3 promise, the RAID works flawless.
> But if I try to build a RAID over HDs of 2 of these Promise PCI Cards,
> the system freeze EVERYTIME.
> System used: Debian sarge, fresh install from friday, raidtools2 and
> kerne 2.4.27
> 
> Does ANYONE have any hints?

Do you have alt-sysrq support compiled in?

If so, does alt-sysrq-t give you any information or is it a complete hard lock.

If it's a hard lock, can you enable the NMI oopser to try and find out where the system is freezing?

> Or does anyone uses a RAID over 2 or more Promise PCI Cards?

Yes, but SATA cards.

Regards,
Brad
