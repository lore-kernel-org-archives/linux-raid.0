From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 22:29:11 +0100
Message-ID: <20369.54567.60804.896644@tree.ty.sabi.co.UK>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F8D228D.8060005@westcontrol.com>
	<20120417171609.GA2859@lazy.lzy>
	<4F8DD02F.1060504@westcontrol.com>
	<4F905690.3060301@zytor.com>
	<CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
	<067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
	<CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
	<4F91B1C4.5080205@hesbynett.no>
	<20120420210106.GA2432@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420210106.GA2432@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> 255 data disks is the theoretical limit for GF(2=E2=81=B8).  But it
>> is a theoretical limit of the algorithms - I don't know
>> whether Linux md raid actually supports that many disks.  I
>> certainly doubt if it is useful.

> The reason to use many disks is in case of geo-redundant RAID,
> for example with iscsi.  In this situation you want to have a
> lot of redundance, in parities, not mirror.

is that something that makes sense? If one has the extreme
requirements implied by that why not use self repairing coding
similarly to Parchive style storage formats, for example Typhoon
or the Azure filesystem or others inspired by Parchive.

Out of interest I just did a small web search and it turned up a
recent survey/lecture by Fr=C3=A9d=C3=A9rique Oggier on the maths of th=
ese
coding systems:

  http://phdopen.mimuw.edu.pl/lato12/LectPoland.pdf
  http://sands.sce.ntu.edu.sg/CodingForNetworkedStorage/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
