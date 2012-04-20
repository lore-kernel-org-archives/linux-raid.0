From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 23:01:06 +0200
Message-ID: <20120420210106.GA2432@lazy.lzy>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
 <4F8D228D.8060005@westcontrol.com>
 <20120417171609.GA2859@lazy.lzy>
 <4F8DD02F.1060504@westcontrol.com>
 <4F905690.3060301@zytor.com>
 <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
 <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
 <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
 <4F91B1C4.5080205@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F91B1C4.5080205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Alex <creamyfish@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again David,

> Yes, being a generator for GF(2^8) is a requirement for a parity
> generator (sorry for the confusing terminology here - if anyone has
> a better suggestion, please say) to be part of a 255 data disk
> system. However, being a GF generator is necessary but not
> sufficient - using parity generators (1, 2, 4, 16) will /not/ give
> quad parity for 255 data disks, even though individually each of 1,
> 2, 4 and 16 are generators for GF.

I ask again, could you please elaborate this?
I nowhere found such a further constrain for the parities.

All I could find is that the Vandermonde matrix must
be done with generators.

> 255 data disks is the theoretical limit for GF(2=E2=81=B8).  But it i=
s a
> theoretical limit of the algorithms - I don't know whether Linux md
> raid actually supports that many disks.  I certainly doubt if it is
> useful.

The reason to use many disks is in case of
geo-redundant RAID, for example with iscsi.
In this situation you want to have a lot of
redundance, in parities, not mirror.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
