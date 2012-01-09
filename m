From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: SMART, RAID and real world experience of failures.
Date: Mon, 9 Jan 2012 13:59:22 +0000
Message-ID: <20234.62138.92901.59114@tree.ty.sabi.co.UK>
References: <4F063808.6040000@crc.id.au>
	<20230.55643.346235.891308@tree.ty.sabi.co.UK>
	<4F06DDAC.1050501@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F06DDAC.1050501@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>>> I got a SMART error email yesterday from my home server with
>>> a 4 x 1Tb RAID6. [ ... ]

>> That's an (euphemism alert) imaginative setup. Why not a 4
>> drive RAID10? [ ... ]

> The main reason is the easy ability to grow the RAID6 to an
> extra drive when I need the space. I've just about allocated
> all of the array to various VMs and file storage. One thats
> full, its easier to add another 1Tb drive, grow the RAID, grow
> the PV and then either add more LVs or grow the ones that need
> it.

That's indeed an (euphemism alert) audacious plan. It has all
the popular ideas that I consider very brave indeed: RAID6,
LVM2, growing arrays in-place, growing filesystems in-place, and
of course VM images on top (following the usual logic I guess
that they will be sparse).

It has been my misfortune to see much the same audacious plan
setup by optimistic predecessors in a few workplaces, and then
having to turn that plan into a less brave one in a hurry when
it ended up as it would. But at least in your case it is just a
home setup.
