From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Sat, 19 May 2012 12:40:17 +0200
Message-ID: <CAAOsTS=pF2HUNUOBv1T50m8gP=6fF_tAt0o-oAQzQr_VTOt+-A@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<4FB43977.8020607@volatilevoid.net>
	<20120518134555.3a9ce08b@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120518134555.3a9ce08b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Oliver Martin <oliver@volatilevoid.net>, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, thanks for your assistance.

I successfully converted 2nd and 3rd array to raid6 with ls-6 layout,
--layout=3Dleft-symmetric-6 worked as advertised.

Reshaping of 1st array finished OK too, even when it did not avoid
power outage at last and was hit by one couple of hours before
finishing. But it restarted without problem, the array was consistent
according check and I also compared important data with backup and
they are OK.

Patrik

On Fri, May 18, 2012 at 5:45 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 17 May 2012 01:34:15 +0200 Oliver Martin <oliver@volatilevoid=
=2Enet>
> wrote:
>
>> Hi Neil,
>>
>> Am 11.05.2012 02:50, schrieb NeilBrown:
>> > Doing an in-place reshape with the new 3.3 code should work, thoug=
h with a
>> > softer "should" than above. =A0We will only know that it is "stabl=
e" when enough
>> > people (such as yourself) try it and report success. =A0If anythin=
g does go
>> > wrong I would of course help you to put the array back together bu=
t I can
>> > never guarantee no data loss. =A0You wouldn't be the first to test=
 the code on
>> > live data, but you would be the second that I have heard of.
>>
>> I guess I'll be taking 2nd place then. I just used it on three live
>> raid6 arrays, and it worked perfectly.
>
> 3 arrays - so you are 2nd, 3rd, and 4th :-)
>
> Thanks. =A0I often get failure reports and only more rarely get succe=
ss
> reports, so I value them all the more.
>
> NeilBrown
>
>
>>
>> Thanks for your all your awesome work!
>>
>> Oliver
>>
>> PS: I wasn't subscribed to the list before, so I'm trying to reply t=
o
>> this via gmane. No idea if this preserves all the list headers - if =
I
>> break the thread, that's probably the cause.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
