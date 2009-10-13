From: "Majed B." <majedb@gmail.com>
Subject: Re: Feature request: ability to exchange drive without failing the
	old one
Date: Tue, 13 Oct 2009 23:44:46 +0300
Message-ID: <70ed7c3e0910131344hcfa6feal8890d71f1e5e4fa6@mail.gmail.com>
References: <bb145bd20910121740n208e4c71v30520a7ea8b57d21@mail.gmail.com>
	<4AD4E534.2010102@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD4E534.2010102@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Christian Pernegger <pernegger@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Isn't this called an active hot spare?

I think some hardware RAID controllers offer this feature: Keeping the
spare in sync with the whole array, so when a failure happens, the
spare takes its place immediately.

That'd be an awesome feature to have!

On Tue, Oct 13, 2009 at 11:38 PM, Bill Davidsen <davidsen@tmr.com> wrot=
e:
> Christian Pernegger wrote:
>>
>> Hi list!
>>
>> Sometimes I want to exchange a drive in an array even if it hasn't
>> actually failed, e. g.
>> - in preperation for a grow operation:
>> exchange-resync-exchange-resync-...-grow
>> - when removing old drives as part of regular maintenance
>> - ...
>>
>> Currently one has to fail an active drive to trigger a resync to the
>> replacement (assuming it was added as a spare beforehand) and thus
>> suffer the loss of fault tolerance and performance until the sync is
>> complete.
>>
>> Suggestion: allow adding drives as an explicit replacement for an
>> active one. The active drive would then be copied to the new one in
>> the background, effectively replacing the component device with a
>> mirror. Bonus points if the resulting setup is a valid mode of
>> operation and not just a temporary hack. I suppose one could see the
>> feature as a special case of the reshaping that's all the rage now :=
)
>>
>
> I think what you want is a subset of the problem many of us face, mov=
ing a
> member of an array to a larger partition on a (much) larger drive. Th=
at
> migration, followed by a grow, is getting more appealing, as various =
drive
> drop to "prize in a cereal box" pricing. And as data grows, backup to
> something other than disk is getting pretty impractical, resulting in=
 unit
> upgrades to save space, time, power, etc, etc.
>
> I agree with the need, I have several ugly methods of doing this whic=
h boil
> down to replacing a member with a raid-1 of the member and the new dr=
ive. I
> have done it several ways, including the "I can't fit another drive i=
n the
> box" solution, using nbd and write mostly. Uglier than a hedgehog's a=
ss, but
> it worked... eventually.
>
> --
> Bill Davidsen <davidsen@tmr.com>
> =C2=A0Unintended results are the well-earned reward for incompetence.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
