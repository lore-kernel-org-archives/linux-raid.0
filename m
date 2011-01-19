From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Wed, 19 Jan 2011 16:34:53 +0700
Message-ID: <AANLkTikcGohtUB2edTvrm47dRg4KRe=ksu=WSYo_J8LZ@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
 <20110119064457.5ab8bdd0@notabene.brown> <AANLkTi=C6Pn9qHXPXX0NCEtEwihb1rVPDM48RUDXD_Eh@mail.gmail.com>
 <20110119203239.0677bba6@notabene.brown>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119203239.0677bba6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 January 2011 16:32, NeilBrown <neilb@suse.de> wrote:
> On Wed, 19 Jan 2011 14:41:10 +0700 Igor Podlesny <for.poige+linux@gma=
il.com>
> wrote:
>
>> > =C2=A0restriction was dropped for RAID0 a year or more ago. =C2=A0=
The restriction
>> > =C2=A0could be dropped for RAID4/5/6 and RAID10 relatively easily.=
 =C2=A0It would just
>> > =C2=A0require a thorough code review and changing a few 'mask' and=
 'shift'
>> > =C2=A0operations to divisions.
>> [...]
>>
>> =C2=A0 =C2=A0Would be really great. Really!
>>
>
> I'm happy to accept patches - after reviewing them of course.

   I bet you do. %-)

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
