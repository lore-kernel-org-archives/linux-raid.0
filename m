From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Sat, 21 Apr 2012 00:31:38 +0200
Message-ID: <20120420223138.GA11308@lazy.lzy>
References: <4F8D228D.8060005@westcontrol.com>
 <20120417171609.GA2859@lazy.lzy>
 <4F8DD02F.1060504@westcontrol.com>
 <4F905690.3060301@zytor.com>
 <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
 <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
 <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
 <4F91B1C4.5080205@hesbynett.no>
 <20120420210106.GA2432@lazy.lzy>
 <20369.54567.60804.896644@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20369.54567.60804.896644@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Peter,

On Fri, Apr 20, 2012 at 10:29:11PM +0100, Peter Grandi wrote:
> [ ... ]
>=20
> >> 255 data disks is the theoretical limit for GF(2=E2=81=B8).  But i=
t
> >> is a theoretical limit of the algorithms - I don't know
> >> whether Linux md raid actually supports that many disks.  I
> >> certainly doubt if it is useful.
>=20
> > The reason to use many disks is in case of geo-redundant RAID,
> > for example with iscsi.  In this situation you want to have a
> > lot of redundance, in parities, not mirror.
>=20
> is that something that makes sense? If one has the extreme
> requirements implied by that why not use self repairing coding
> similarly to Parchive style storage formats, for example Typhoon
> or the Azure filesystem or others inspired by Parchive.

it depends on other requirements, for example if
you want to control your file or let the control
to the "cloud".
In case of RAID, the cloud sees only raw bytes
and the local host sees the files too.

In case of par2, the cloud must see the files.

BTW, this is not my original idea, there is
someone doing, already mentioned, a RAID-96
with RS(96,64) over networked virtual drives.

> Out of interest I just did a small web search and it turned up a
> recent survey/lecture by Fr=C3=A9d=C3=A9rique Oggier on the maths of =
these
> coding systems:
>=20
>   http://phdopen.mimuw.edu.pl/lato12/LectPoland.pdf
>   http://sands.sce.ntu.edu.sg/CodingForNetworkedStorage/

Interesting, I'll have a look.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
