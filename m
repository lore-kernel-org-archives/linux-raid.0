From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 14:48:58 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810311446510.7167@p34.internal.lan>
References: <39398.82011.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39398.82011.qm@web30802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 31 Oct 2008, Mike Myers wrote:

> Well, actually if the chips that manufacturer A uses are faster in software raid than manufacturer L...  :-)
>
> thx
> mike
>
>
Mike,

What sustained rates for sequential read/writes have you been able to 
achieve with multiple (HW) based PCI-X RAID cards?

Isn't there a drop in performance when exporting a drive via JBOD vs. 
directly attached to a SATA controller?  I remember raptors on a SiI 3112 
(or the raid chip on an ABIT IC7-G, its been awhile)-- in RAID mode on a 
motherboard, it was (this was a while ago) 40-50MiB/s whereas the same raptor
connected to a regular sata controller was closer to 70-80MiB/s (74GiB raptor).

Justin.


