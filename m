From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Fri, 10 May 2002 23:36:09 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020510233206.17988A-100000@Maggie.Linux-Consulting.com>
References: <Pine.LNX.4.30.0205110758030.17857-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.30.0205110758030.17857-100000@duplo.agenda.si>
To: Danilo Godec <danci@agenda.si>
Cc: Artur Jasowicz <arturj@mousebusiness.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya artur

On Sat, 11 May 2002, Danilo Godec wrote:

> On Fri, 10 May 2002, Artur Jasowicz wrote:
> 
> > The more I think about it the more it seems like the system not
> > keeping up with the drives though. Isn't it strange that both my 2000+

make sure that all your disks on the same ide cable is of the same
speed...  and its options defined similarly...
	ata33 on one cable...
	ata66 on a 80-pin ide cable - no other disk speeds
	ata100 on a different ide cable
	ata133 on a different ide cable..
	-- do NOT mix drives of different ata speeds..

	hdparam -iv /dev/hdxx  will tell you what speed it is

make sure that your cables are good/clean and not bent out of shape..

http://www.linux-1u.net/Disks

c ya
alvin

> It's a wild guess, but you might want to try disabling one of the
> processors using 'nosmp' kernel parameter. Maybe Athlons have some issues
> with SMP configuration.
> 
> Next would be testing a single drive. If the problem exists using a single
> drive, you should try some other controller (I never used a HPT, but a
> friend of mine has a problem with it - dunno what exactly though).
> 
> OR, having three IDE controllers sharing one IRQ just might be a problem.
> I remember that on my SMP motherboards I had a lot more available IRQs
> (over 25), available through APIC (whatever that is).
> 

