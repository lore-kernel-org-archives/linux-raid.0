From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 00:30:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021120233020.GE29881@marowsky-bree.de>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <3DDBC0D9.5030904@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DDBC0D9.5030904@mvista.com>
To: Steven Dake <sdake@mvista.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2002-11-20T10:05:29,
   Steven Dake <sdake@mvista.com> said:

> This could be done without this field, but then the RAID arrays could=
 be=20
> started unintentionally by the wrong host.  Imagine a host starting t=
he=20
> wrong RAID array while it has been already started by some other part=
y=20
> (forcing a rebuild) ugh!

This is already easy and does not require addition of a field to the md
superblock.

Just only explicitly start disks with the proper uuid in the md superbl=
ock.
Don't simply start them all.

(I'll reply to Neil's mail momentarily)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Principal Squirrel=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
