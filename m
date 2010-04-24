From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5
Date: Fri, 23 Apr 2010 20:34:02 -0700
Message-ID: <k2i4877c76c1004232034m5c3f79b0s827a92e9349fa7a2@mail.gmail.com>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>
	 <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>
	 <4BCEFE66.6010607@tmr.com>
	 <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>
	 <4BD1AE0C.2040003@msgid.tls.msk.ru>
	 <o2u4877c76c1004231357x649c5979ncd3e10ea8e6060d1@mail.gmail.com>
	 <alpine.DEB.1.10.1004240340510.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1004240340510.6768@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Bill Davidsen <davidsen@tmr.com>, Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 23, 2010 at 6:47 PM, Mikael Abrahamsson <swmike@swm.pp.se> =
wrote:
> On Fri, 23 Apr 2010, Michael Evans wrote:
>
>> devices, but now everyone is selling SDDs which are broken for such
>> needs. =A0Any ram drive units still being sold seem to be more along
>> data-center grade sizes.
>
> http://benchmarkreviews.com/index.php?option=3Dcom_content&task=3Dvie=
w&id=3D308&Itemid=3D60
>
> Basically it's DRAM with a battery backup and a CF slot where the dat=
a goes
> in case of poewr failure. It's a bit big and so on, but it should be =
perfect
> for journals... Or is this the kind of device you were referring to a=
s "data
> center grade size"?
>
> Some of te SSDs sold today have a capacitor for power failure as well=
, so
> all writes will complete, but they're not so common.
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>

Yeah, that's in the range I call 'data center grade' since the least
expensive model I can find using search tools is about 236 USD.  For
that price I could /buy/ two to three hard drives and get nearly the
same effect by reusing old drives (but wasting more power).

I should be able to find something with a cheep plastic shell for
mounting and a very simple PCB that has slots for older ram of my
selection, and a minimal onboard CPU for less than 50USD; I seriously
doubt the components cost that much.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
