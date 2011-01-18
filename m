From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 16:53:00 -0200
Message-ID: <AANLkTinuJ_vQxdygGyN2ARHDLfM5gEbd1LD6d8c=OMfV@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<4D35C9BB.20908@anonymous.org.uk>
	<AANLkTimn9j08BPvE0hZdBk3NvqJ6_iQELQczBOA8LruO@mail.gmail.com>
	<4D35D67B.20004@anonymous.org.uk>
	<AANLkTin-RcJNR+gUc711R7Z1gAfx9ZFazvQz4AbR0Ugn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin-RcJNR+gUc711R7Z1gAfx9ZFazvQz4AbR0Ugn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thinking about performace, and rewrite the first question....
could we optimize something (at raid software) about chunck, blocks
and other thinks (used at filesystem space, not lvm or database direct
device access)?
ok... they should adjust the code to our raid source...
we can propose some tweaks for especific filesystems?
ok, who developed filesystems should make especific benchmarks....

again... could we implement some optimization for the first question?
thanks

2011/1/18 Igor Podlesny <for.poige+linux@gmail.com>:
> On 19 January 2011 01:05, John Robinson <john.robinson@anonymous.org.=
uk> wrote:
>> On 18/01/2011 17:23, Igor Podlesny wrote:
> [...]
>>> =A0 =A0Am I? Take a look
>>>
>>> http://www.freebsd.org/cgi/man.cgi?query=3Dvinum&apropos=3D0&sektio=
n=3D0&manpath=3DFreeBSD+4.9-RELEASE&format=3Dhtml
>>
>> Why should I be reading FreeBSD man pages when this is a Linux list?=
 I am
>> using the terms stripe size and chunk size in the sense I understand=
 them,
>> which is I believe the Linux sense. If you and FreeBSD choose to use=
 the
>
> =A0 Have you ever configured any "hardware" controller? Have seen wor=
ds
> "stripe size" there?
> =A0 (You can give no answer, of course.)
>
>> terms differently, so be it, but please don't pull me up about my us=
e of
>> terms when you're the one using the wrong ones in this context.
>> [...]
>>>>
>>>> Secondly, as far as I know all Linux filesystems are RAID-aware so=
 know
>>>> how
>>>
>>> =A0 =A0You're mistaken. There're too many are not.
>>
>> I'll concede, only all the major filesystems you'd ever use in a pro=
duction
>> environment.
>
> =A0 I don't care what you think is ready for production and what is
> not. There're people who still think that Linux isn't production
> ready. (Though I don't care either.)
>>
> [...]
>>
>>> =A0 =A0P. S. I think now everyone can see why this letter was
>>> intentionally addressed to the author of LSR, not to the list.
>>
>> There's absolutely no need for that. Please leave, and take your
>> condescension, ignorance and offensiveness with you.
>
> =A0 So nice to see that all those words is highly related to you in t=
he
> first place: "Why should I read man from freebsd", "I use terms in th=
e
> sense I understand them". Hey, what a stupidity, dare I ask? :-)
>
> =A0 John Robinson, I didn't ask you to peek your nose into this
> conversation. Calm down, take a rest. You can take a look at manual o=
f
> your mailer to ignore mails from people you don't wanna read. Don't
> ask me why you should read man(s). And just before jumping in with a
> nonsense like "You're slightly confusing things", please make a
> favour: RTFM.
>
> --
> End of message. Next message?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
