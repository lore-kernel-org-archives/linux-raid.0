From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Events?
Date: Sun, 31 May 2009 13:42:24 +0530
Message-ID: <37d33d830905310112h74de2612i745376ee7f3baf56@mail.gmail.com>
References: <18977.43320.811246.171065@notabene.brown>
	 <20090531013717425.YKVV5991@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090531013717425.YKVV5991@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 31, 2009 at 7:07 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> -----Original Message-----
>> From: Neil Brown [mailto:neilb@suse.de]
>> Sent: Saturday, May 30, 2009 4:47 PM
>> To: lrhorer@satx.rr.com
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: Events?
>>
>> On Saturday May 30, lrhorer@satx.rr.com wrote:
>> >
>> > What does the "Events" field reported by -Dt signify, and why does=
 the
>> > number sometimes decrease? =A0I've seen the number change, but I d=
on't see
>> > anything in any of the system logs corresponding to something that=
 would
>> > seem to relate.
>>
>> Changes just as device failure and adding or removing a device.
>> Also transitions from 'active' to 'clean' and back.
>
> OK, but shouldn't these transitions at least be logged somewhere?
>
>> Sometimes the dirty->transition causes the event counter to retreat =
if
>> md is use the new 'clean' state is indistinguishable from the old
>> 'clean' state. =A0This allows us not to always be waking up spare dr=
ives
>> just to tell them about clean->active->clean transitions.
>
> That makes sense, but I think the admin should be able to inspect the
> details of the transactions.
>

Yes, this really can be very useful for any inspection, we should
surely log any state changes.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
