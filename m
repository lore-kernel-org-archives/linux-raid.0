From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Thu, 13 Aug 2009 10:08:34 +0200
Message-ID: <20090813080834.GA24883@rap.rap.dk>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com> <c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com> <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com> <87vdkt4e5x.fsf@frosties.localdomain> <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com> <a43edf1b0908120900u32226a01w16edc9075282ee9f@mail.gmail.com> <874osc5ut5.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874osc5ut5.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Billy Crook <billycrook@gmail.com>, "Henry, Andrew" <andrew.henry@logica.com>, Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 13, 2009 at 04:09:10AM +0200, Goswin von Brederlow wrote:
> Billy Crook <billycrook@gmail.com> writes:
>=20
> > On Wed, Aug 12, 2009 at 04:14, Henry, Andrew<andrew.henry@logica.co=
m> wrote:
> >> That's what my question was: =A0Will raid0 (striping) be faster or=
 easier to manage than lvm striping
> >
> > LVM striping won't change performance for small files. (That is fil=
es,
> > smaller than the extent size.)  To be fair, RAID-0 striping won't
> > accelerate file access for files smaller than the stripe size eithe=
r.

Have you tested this? In theory, both LVM and raid0 striping should
accellerate access to small files substantially, for example if a
process accesses a number of small files, which are laid out in sequenc=
e
on the file system. This is a common case.=20

I think this could come about eg if you roll in a tarball or package of
a system, then the small files are created in sequence, and the file
system should lay them out in sequence on the disk. When reading again,
the disk read ahead would secure that most of the data for a number of
small files were already read into the kernel cache when asked for, and
thus the files would be read at striping speeds.=20

> > However, traditionally, raid0 stripe sizes are much much smaller th=
an
> > LVM extent sizes.  Both are however adjustable.

What are the parameters? raid normally assumes 64 kiB chunks, but i
normally use 256 kiB chunks, which is the lowest chunk size that we are
recommending out of the linux-raid group. What are normal with LVM?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
