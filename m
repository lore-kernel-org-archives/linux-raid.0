From: Scott Long <scott_long@adaptec.com>
Subject: Re: Proposed enhancements to MD
Date: Tue, 13 Jan 2004 15:44:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <400474D6.30705@adaptec.com>
References: <20040113233320.23e4cfef.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040113233320.23e4cfef.pegasus@nerv.eu.org>
To: =?UTF-8?B?SnVyZSBQZcSNYXI=?= <pegasus@nerv.eu.org>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Jure Pe=C4=8Dar wrote:
> On Tue, 13 Jan 2004 13:41:07 -0700
> Scott Long <scott_long@adaptec.com> wrote:
>=20
>=20
>>A problem that we've encountered, though, is the following sequence:
>>
>>1) md is inialized during boot
>>2) drives X Y and Z are probed during boot
>>3) root fs exists on array [X Y Z], but md didn't see them show up,
>>    so it didn't auto-configure the array
>>
>>I'm not sure how this can be addressed by a userland daemon.  Remembe=
r
>>that we are focused on providing RAID during boot; configuring a
>>secondary array after boot is a much easier problem.
>=20
>=20
> Looking at this chicken-and-egg problem of booting from an array from
> administrator's point of view ...
>=20
> What do you guys think about Intel's EFI? I think it would be the mos=
t
> apropriate place to put a piece of code that would scan the disks,
> assemble
> any arrays and present them to the OS as bootable devices ... If we'r=
e
> going
> to get a common metadata layout, that would be even easier.
>=20
> Thoughts?
>=20

The BIOS already scans the disks, assembles the arrays, and presents
finds the boot sector, and presents the arrays to the loader/GRUB.  Are
you saying that EFI should be the interface by which the arrays are
communicated through, even after the kernel has booted?  Is this
possible right now?

Scott
