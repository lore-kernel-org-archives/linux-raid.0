From: pglxra2.for.sabi.co.UK@vger.kernel.org (Peter Grandi)
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Sat, 21 Apr 2012 10:51:14 +0100
Message-ID: <20370.33554.998900.245328@tree.ty.sabi.co.UK>
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
	<20120420223138.GA11308@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420223138.GA11308@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>> 255 data disks is the theoretical limit for GF(2=E2=81=B8). [ ... =
]

>>> The reason to use many disks is in case of geo-redundant RAID,
>>> for example with iscsi.  In this situation you want to have a
>>> lot of redundance, in parities, not mirror.

>> [ ... ] extreme requirements implied by that why not use self
>> repairing coding similarly to Parchive style storage formats,
>> [ ... ]

> it depends on other requirements, for example if you want to
> control your file or let the control to the "cloud".  In case
> of RAID, the cloud sees only raw bytes and the local host sees
> the files too. In case of par2, the cloud must see the
> files. [ ... ]

Perhaps it was not clear that "use self repairing coding
similarly to Parchive" does not mean the same as "use Parchive".

Applying self repairing coding to RAID might be easier to
imagine considering of a RAID volume as a directory of
stripe-sized files.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
