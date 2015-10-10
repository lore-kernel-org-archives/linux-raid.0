From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke cryptsetup on my
 machine
Date: Sat, 10 Oct 2015 09:00:01 -0400
Message-ID: <20151010130000.GA1079@redhat.com>
References: <alpine.LNX.2.20.1510072226180.1350@localhost.localdomain>
 <20151008123849.GA4279@ubuntu>
 <alpine.LNX.2.20.1510101543410.1998@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.1510101543410.1998@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Giedrius =?utf-8?Q?Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 10 2015 at  8:44P -0400,
Giedrius Statkevi=C4=8Dius <giedrius.statkevicius@gmail.com> wrote:

> On Thu, 8 Oct 2015, Geliang Tang wrote:
>=20
> > On Wed, Oct 07, 2015 at 10:27:27PM +0300, Giedrius Statkevi=C4=8Diu=
s wrote:
> > > Hello,
> > > I have a LUKS on LVM setup: /boot is unencrypted and everything i=
s "hidden" in
> > > /dev/sda2. After booting on linux-next and just after entering my=
 password
> > > cryptsetup segfaults and a stack trace is printed from the kernel=
=2E Since writing
> > > down all those numbers is hard I've made a picture where it is sh=
own:
> > > https://i.imgur.com/6PHNUdv.jpg
> > >=20
> > > I figured it had something to do with changes to memory managemen=
t and thus find
> > > out that commit 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke my=
 system.
> > > Reverting it there is no such error anymore and system boots fine=
 past that
> > > point.=20
> > >=20
> > > Could someone look into this? Thanks, Giedrius
> >=20
> > Bugfix for this has been sended out.
> > https://lkml.org/lkml/2015/10/8/342.
> >=20
> > Thanks.
> I've tested and that fixed this issue for me. I would've replied on t=
hat thread
> but I can't find its Message-Id. Anyway, you can add:
> Tested-By: Giedrius Statkevi=C4=8Dius <giedrius.statkevicius@gmail.co=
m>

I dropped the original commit because I'm really not seeing the value o=
f
using kvfree (but it was motivated by reports of crashes from ktest,
etc).  I don't have any intention of picking it back up at this point
(so Geliang's fix will go unused at this point).

Mike
