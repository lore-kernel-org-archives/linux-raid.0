From: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Subject: Re: Proposed enhancements to MD
Date: Tue, 13 Jan 2004 23:33:20 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113233320.23e4cfef.pegasus@nerv.eu.org>
References: <40043C75.6040100@pobox.com>
	<400457E3.5030602@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400457E3.5030602@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

On Tue, 13 Jan 2004 13:41:07 -0700
Scott Long <scott_long@adaptec.com> wrote:

> A problem that we've encountered, though, is the following sequence:
>=20
> 1) md is inialized during boot
> 2) drives X Y and Z are probed during boot
> 3) root fs exists on array [X Y Z], but md didn't see them show up,
>     so it didn't auto-configure the array
>=20
> I'm not sure how this can be addressed by a userland daemon.  Remembe=
r
> that we are focused on providing RAID during boot; configuring a
> secondary array after boot is a much easier problem.

Looking at this chicken-and-egg problem of booting from an array from
administrator's point of view ...

What do you guys think about Intel's EFI? I think it would be the most
apropriate place to put a piece of code that would scan the disks, asse=
mble
any arrays and present them to the OS as bootable devices ... If we're =
going
to get a common metadata layout, that would be even easier.

Thoughts?

--=20

Jure Pe=C4=8Dar
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
