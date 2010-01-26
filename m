From: Asdo <asdo@shiftmail.org>
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 16:07:43 +0100
Message-ID: <4B5F053F.2070607@shiftmail.org>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
 <4B5EB5BD.7070406@shiftmail.org>
 <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
 <4B5EEFD7.2080407@shiftmail.org>
 <37bfaf9c6cbe90557cdef839be3ff20f.squirrel@www.dcsnow.com>
 <1264517763.30742.88.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1264517763.30742.88.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Micha=C5=82 Sawicz wrote:
> Dnia 2010-01-26, wto o godzinie 09:36 -0500, aragonx@dcsnow.com pisze=
:
>  =20
>> Poor wording on my part.  Yes I tried to assemble the array several
>> times
>> under Fedora 12 and Knoppix 6.2.  It would not start so then I tried
>> the
>> create.  Either way the data is gone and that answers my question.=20
>>    =20
>
> You should have also used '--assume-clean' so that no data would be
> written onto the array while the array was assembled. Saved my ass
> earlier.

--assume-clean is a create option not an assemble option.

Assemble should never destroy data. If it really happened it's a bug bu=
t=20
we don't have much information.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
