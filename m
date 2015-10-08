From: Geliang Tang <geliangtang@163.com>
Subject: Re: 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke cryptsetup on my
 machine
Date: Thu, 8 Oct 2015 05:38:49 -0700
Message-ID: <20151008123849.GA4279@ubuntu>
References: <alpine.LNX.2.20.1510072226180.1350@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.1510072226180.1350@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Giedrius =?utf-8?Q?Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>
Cc: snitzer <snitzer@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 07, 2015 at 10:27:27PM +0300, Giedrius Statkevi=C4=8Dius wr=
ote:
> Hello,
> I have a LUKS on LVM setup: /boot is unencrypted and everything is "h=
idden" in
> /dev/sda2. After booting on linux-next and just after entering my pas=
sword
> cryptsetup segfaults and a stack trace is printed from the kernel. Si=
nce writing
> down all those numbers is hard I've made a picture where it is shown:
> https://i.imgur.com/6PHNUdv.jpg
>=20
> I figured it had something to do with changes to memory management an=
d thus find
> out that commit 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke my sys=
tem.
> Reverting it there is no such error anymore and system boots fine pas=
t that
> point.=20
>=20
> Could someone look into this? Thanks, Giedrius

Bugfix for this has been sended out.
https://lkml.org/lkml/2015/10/8/342.

Thanks.
