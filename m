From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Thu, 13 Aug 2009 04:09:10 +0200
Message-ID: <874osc5ut5.fsf@frosties.localdomain>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
	<c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com>
	<87vdkt4e5x.fsf@frosties.localdomain>
	<3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com>
	<a43edf1b0908120900u32226a01w16edc9075282ee9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0908120900u32226a01w16edc9075282ee9f@mail.gmail.com>
	(Billy Crook's message of "Wed, 12 Aug 2009 11:00:51 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: "Henry, Andrew" <andrew.henry@logica.com>, "goswin-v-b@web.de" <goswin-v-b@web.de>, Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Billy Crook <billycrook@gmail.com> writes:

> On Wed, Aug 12, 2009 at 04:14, Henry, Andrew<andrew.henry@logica.com>=
 wrote:
>> That's what my question was: =A0Will raid0 (striping) be faster or e=
asier to manage than lvm striping
>
> LVM striping won't change performance for small files. (That is files=
,
> smaller than the extent size.)  To be fair, RAID-0 striping won't
> accelerate file access for files smaller than the stripe size either.
> However, traditionally, raid0 stripe sizes are much much smaller than
> LVM extent sizes.  Both are however adjustable.

That sucks. LVM striping really should have a setting where it stripes
chunks within a PE.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
