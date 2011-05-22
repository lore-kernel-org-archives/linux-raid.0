From: Tobias McNulty <tobias@caktusgroup.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 16:57:37 -0400
Message-ID: <BANLkTi=az3ny5m7Mf20t5fnFj79CsowJWg@mail.gmail.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com>
 <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com>
 <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com>
 <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9633E.5000101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 22, 2011 at 3:25 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
>
> On 5/22/2011 5:09 AM, Brad Campbell wrote:
> > On 22/05/11 17:04, Stan Hoeppner wrote:
> >> It's difficult to align partitions properly on the Green drives du=
e to
> >> native 4K sectors translated by drive firmware to 512B sectors. =A0=
The
> >> Seagate SAS drive has native 512B sectors.
> >
> > Actually it's not difficult at all. You just make sure all your
> > partitions start on an even multiple of 8 sectors. No magic in it. =
Just
> > the same as all my SSD partitions start on 512k boundaries.
>
> IIRC from discussions here, mdadm has alignment issues with hybrid
> sector size drives when assembling raw disks. =A0Not everyone assembl=
es
> their md devices from partitions. =A0Many assemble raw devices.

Case in point: I have 4 of these 2TB Green drives in a RAID5 array.  I
assembled them from the raw devices (no partition table) without any
special precautions.  Am I in trouble?  The array seems to be working
fine...

Tobias
--
Tobias McNulty, Managing Member
Caktus Consulting Group, LLC
http://www.caktusgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
