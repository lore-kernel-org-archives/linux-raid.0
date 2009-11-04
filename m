From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Tue, 3 Nov 2009 16:11:44 -0800
Message-ID: <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
	 <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
	 <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>
	 <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: Sujit K M <sjt.kar@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 3, 2009 at 11:29 AM, Chris Worley <worleys@gmail.com> wrote=
:
> On Tue, Nov 3, 2009 at 9:31 AM, Michael Evans <mjevans1983@gmail.com>=
 wrote:
>> Is it possible the data-set you are testing with is too small? =A0Mo=
dern
>> drives have caches of around 32MB, your test might only be executing
>> within the drive's caches.
>
> Cache is disabled on the drives, and disabled on the system by using
> O_DIRECT on the benchmark. =A0I am seeing proper behavior using
> synchronous writes, but that slows down performance too much.
>

I'm not familiar with O_DIRECT so I looked it up:
http://www.kernel.org/doc/man-pages/online/pages/man2/open.2.html

It -appears- that O_DIRECT merely attempts to efficiently map
transfers as full blocks/allocation units.  I see no mention, within
the context of O_DIRECT of buffering or not (and presume it -is-
buffered by default).

This page provides additional detail:
http://www.ukuug.org/events/linux2001/papers/html/AArcangeli-o_direct.h=
tml

It seems that O_DIRECT disables any kernel-side caches for operations,
but does not modify any caching that might be performed by the
underlying block devices.  O_DIRECT might not even be applicable with
an MD/DM device.


O_DIRECT (Since Linux 2.4.10)
              Try to minimize cache effects of the I/O to and from
this file.  In
              general this will degrade performance, but it is useful i=
n special
              situations, such as when applications do their own
caching.  File I/O
              is done directly to/from user space buffers.  The
O_DIRECT flag on its
              own makes at an effort to transfer data synchronously,
but does not
              give the guarantees of the O_SYNC that data and
necessary metadata are
              transferred.  To guarantee synchronous I/O the O_SYNC
must be used in
              addition to O_DIRECT.  See NOTES below for further discus=
sion.

              A semantically similar (but deprecated) interface for
block devices is
              described in raw(8).

As that quote from the manual states, to get the effect you desire you
must use -both- O_DIRECT and O_SYNC.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
