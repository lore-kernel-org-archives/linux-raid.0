From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 16:21:32 +0100
Message-ID: <1156432892.3007.155.camel@localhost.localdomain>
References: <20060824090741.J30362@mail.kroptech.com>
	 <1156425650.3007.140.camel@localhost.localdomain>
	 <44EDB843.2020608@perkel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44EDB843.2020608@perkel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Perkel <marc@perkel.com>
Cc: Adam Kropelin <akropel1@rochester.rr.com>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ar Iau, 2006-08-24 am 07:31 -0700, ysgrifennodd Marc Perkel:
> So - the bottom line answer to my question is that unless you are
> running raid 5 and you have a high powered raid card with cache and
> battery backup that there is no significant speed increase to use
> hardware raid. For raid 0 there is no advantage.
> 
If your raid is entirely on PCI plug in cards and you are doing RAID1
there is a speed up using hardware assisted raid because of the PCI bus
contention. If your controllers are PCI express, on internal high speed
busses (eg chipset controllers) or at least half of them are then
generally there is no win with hardware raid 0/1 and it is often slower.


