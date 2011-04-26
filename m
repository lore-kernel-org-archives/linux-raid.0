From: Luca Berra <bluca@comedia.it>
Subject: Re: Mdadm, udev and fakeraid?
Date: Tue, 26 Apr 2011 08:06:00 +0200
Message-ID: <20110426060600.GA24583@maude.comedia.it>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com> <20110405162008.5f2c48fe@notabene.brown> <BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com> <20110418103852.2ead1a69@notabene.brown> <BANLkTik6qpCx-Y=DXY6U6yu0habSohyiPw@mail.gmail.com> <20110423184551.7bb437de@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110423184551.7bb437de@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 23, 2011 at 06:45:51PM +1000, NeilBrown wrote:
>On Fri, 22 Apr 2011 19:37:40 -0700 Dan Williams <dan.j.williams@gmail.=
com>
>wrote:
>
>> On Sun, Apr 17, 2011 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:
>
>> > As has been mentioned elsewhere, mdadm only recognised IMSM arrays=
 on
>> > machines with IMSM hardware. =A0I'm not entirely happy about this =
and may well
>> > change it.
>>=20
>> I have trouble answering the "least surprise" question in this area.
>>=20
>> Is it more surprising to go into your BIOS, explicitly turn off raid
>> support and still see raid devices showing up?
>
>Is the "RAID support has been explicitly turned off" state visible fro=
m a
>running kernel? or is it indistinguishable from "platform does not hav=
e RAID
>support"?
you can try guessing, intel controllers change their pci product_id bas=
ed on the
mode they are set to operate in bios.

L.

--=20
Luca Berra -- bluca@comedia.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
