From: Chris Worley <worleys@gmail.com>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Tue, 3 Nov 2009 17:21:14 -0700
Message-ID: <f3177b9e0911031621p29c390e4xc5017001a38046ff@mail.gmail.com>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
	 <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
	 <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>
	 <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>
	 <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Sujit K M <sjt.kar@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 3, 2009 at 5:11 PM, Michael Evans <mjevans1983@gmail.com> w=
rote:
> On Tue, Nov 3, 2009 at 11:29 AM, Chris Worley <worleys@gmail.com> wro=
te:
>> On Tue, Nov 3, 2009 at 9:31 AM, Michael Evans <mjevans1983@gmail.com=
> wrote:
>>> Is it possible the data-set you are testing with is too small? =A0M=
odern
>>> drives have caches of around 32MB, your test might only be executin=
g
>>> within the drive's caches.
>>
>> Cache is disabled on the drives, and disabled on the system by using
>> O_DIRECT on the benchmark. =A0I am seeing proper behavior using
>> synchronous writes, but that slows down performance too much.
>>
>
> I'm not familiar with O_DIRECT so I looked it up:
> http://www.kernel.org/doc/man-pages/online/pages/man2/open.2.html
>
> It -appears- that O_DIRECT merely attempts to efficiently map
> transfers as full blocks/allocation units. =A0I see no mention, withi=
n
> the context of O_DIRECT of buffering or not (and presume it -is-
> buffered by default).
>
> This page provides additional detail:
> http://www.ukuug.org/events/linux2001/papers/html/AArcangeli-o_direct=
=2Ehtml
>
> It seems that O_DIRECT disables any kernel-side caches for operations=
,
> but does not modify any caching that might be performed by the
> underlying block devices. =A0O_DIRECT might not even be applicable wi=
th
> an MD/DM device.
>
>
> O_DIRECT (Since Linux 2.4.10)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Try to minimize cache effects of the I/O t=
o and from
> this file. =A0In
> =A0 =A0 =A0 =A0 =A0 =A0 =A0general this will degrade performance, but=
 it is useful in special
> =A0 =A0 =A0 =A0 =A0 =A0 =A0situations, such as when applications do t=
heir own
> caching. =A0File I/O
> =A0 =A0 =A0 =A0 =A0 =A0 =A0is done directly to/from user space buffer=
s. =A0The
> O_DIRECT flag on its
> =A0 =A0 =A0 =A0 =A0 =A0 =A0own makes at an effort to transfer data sy=
nchronously,
> but does not
> =A0 =A0 =A0 =A0 =A0 =A0 =A0give the guarantees of the O_SYNC that dat=
a and
> necessary metadata are
> =A0 =A0 =A0 =A0 =A0 =A0 =A0transferred. =A0To guarantee synchronous I=
/O the O_SYNC
> must be used in
> =A0 =A0 =A0 =A0 =A0 =A0 =A0addition to O_DIRECT. =A0See NOTES below f=
or further discussion.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0A semantically similar (but deprecated) in=
terface for
> block devices is
> =A0 =A0 =A0 =A0 =A0 =A0 =A0described in raw(8).
>
> As that quote from the manual states, to get the effect you desire yo=
u
> must use -both- O_DIRECT and O_SYNC.
>

So, you're saying that the MD layer is doing it's own buffering?  Are
you sure?  With the system cache disabled and the drive (and block
device driver) cache disabled, there should be no reason to require
synchronous I/O, unless, as you suggest, the MD layer is broken.

You're saying that both O_DIRECT and O_SYNC must be used to disable
cache effects. Why then are there two separate flags and not just one?
 Synchronous is a very different behavior that is not necessary for
this test and put additional requirements that are not needed for this
test.

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
