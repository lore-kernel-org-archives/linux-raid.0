From: Drew <drew.kay@gmail.com>
Subject: Port Multipliers
Date: Thu, 10 Sep 2009 05:56:25 -0700
Message-ID: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I've been reading up on port multipliers and I was wondering if
anyone's had any experience with them they'd like to share. From what
I've read of them I would expect the performance to be slower but how
much slower are they in the real world?

I ask because I'm exploring options for my organization and we're
looking at some large JBOD enclosures that can handle up to 15 SATA
drives and I'm trying to minimize performance impact on the drives
while at the same time minimize the amount of cabling between the
openfiler and the enclosure. The server using the enclosure will be
running openfiler as a backend iSCSI target(?) for a couple of VMware
ESXi hosts and while the hosts won't be running anything heavy duty,
mainly just filesharing & email, I'm hoping to keep things running as
fast as possible.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
