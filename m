From: Danilo Godec <danci@agenda.si>
Subject: Re: Non-equal sized partitions vs RAID 1
Date: Mon, 1 Jul 2002 13:54:44 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0207011342230.20670-100000@duplo.agenda.si>
References: <3D203D2A.5030307@partyticket.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D203D2A.5030307@partyticket.net>
To: Flemming Frandsen <ff@partyticket.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Jul 2002, Flemming Frandsen wrote:

> Now for the questions:
> * Is there a way to change the logical geometry of disk 2, so I can
> partition correctly (well if there is then this post is OT)?

You can use 'hdx=c,h,s' kernel parameter on boot. You can also use fdisk's
expert menu to change the geometry while creating the partitions. I don't
know if the later alone is enough, I prefer to use the kernel parameter
and only use the fdisk trick to skip one reboot.

Remember to replace 'hdx' with your actual device name... :)

> * Is there a way to force the array to keep being the same size, even
> after the smaller partition has failed?

After the array is created, it doesn't (shouldn't) change.

> * Why does the BIOS think that it's cool to translate similar disks
> differently, are BIOS writers crackheads or was I just unlucky?

All BIOSes seem to do that: Disks, connected to the primary IDE interface
show 'correct' geometry, while disks, connected to the secondary interface
don't. I hoped it would go away with recent bioses, but I'm affraid I'll
just have to get used to it... :/


   D.

-- 
___________________________________________________________________
|    Danilo Godec    |     Agenda d.o.o.    |   ISP for business  |
|  jr. Syst. Admin   |    Gosposvetska 84   |     WAN networks    |
|  danci@agenda.si   |    si-2000 Maribor   |  Internet/Intranet  |
| tel:+386.2.2340860 |       Slovenija      | Application servers |
| fax:+386.2.2340854 | http://www.agenda.si |  Caldera OpenLinux  |


