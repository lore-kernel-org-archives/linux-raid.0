From: Raz <raziebe@gmail.com>
Subject: Re: Re-size RAID-10
Date: Thu, 26 Mar 2009 10:22:40 +0200
Message-ID: <5d96567b0903260122r19ac19b2u943a82aac2852197@mail.gmail.com>
References: <49CAA763.3050405@amfes.com> <18890.44223.469.924083@notabene.brown>
	<20090326081418.GB23977@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090326081418.GB23977@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, "Daniel L. Miller" <dmiller@amfes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/3/26 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> On Thu, Mar 26, 2009 at 09:14:22AM +1100, Neil Brown wrote:
>> On Wednesday March 25, dmiller@amfes.com wrote:
>> > I think I asked this once before, if so I apologize for the redund=
ancy -
>> > but then again maybe something's changed...
>> >
>> > I've got a RAID-10 array with four drives. =A0It's nearing capacit=
y, and I
>> > need to explore expansion options. =A0Can I simply add a pair of n=
ew
>> > drives? =A0Or do I have to archive the information first and rebui=
ld the
>> > array from scratch?
>>
>> It is not currently possible to resize a raid-10.
>
> In my mind, it should not be that difficult, tho, to do it.
>
> Is resize an operation that needs to be done with the fs unmounted?
No. in raid5 there is no need for that.
> best regards
> keld
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
