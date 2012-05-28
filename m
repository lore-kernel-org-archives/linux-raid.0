From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Mon, 28 May 2012 10:37:14 +0800
Message-ID: <CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
 <20120527220007.64fb230b@notabene.brown> <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
 <20120528114550.417ae379@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120528114550.417ae379@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 May 2012 09:45, NeilBrown <neilb@suse.de> wrote:
> On Mon, 28 May 2012 00:10:33 +0800 Igor M Podlesny <for.poige+lsr@gma=
il.com>
> wrote:
>
>> On 27 May 2012 20:00, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 27 May 2012 19:32:40 +0800 Igor M Podlesny <for.poige+lsr@=
gmail.com>
>> > wrote:
>> >> =C2=A0 =C2=A0A power outage has happened to system (which was in =
"suspend"
>> >> state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 wa=
s
>> >> fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
>> >> auto-readonly mode with resync=3DDELAYED. When they flipped to
>> >> Read-Write, LSR started re-syncing not using bitmaps seemingly. A=
 bug?
>> >
>> > Maybe. =C2=A0But with so little detail it is hard to say.
>> > What made you think the bitmaps weren't being used?
>>
>> =C2=A0 =C2=A0Well, it is reasonable to assume that host being put in=
 suspend
>> mode wouldn't have much not synced data at all. RAID-10 had been
>> progressing its resync quite fast, it was obvious that it had been
>> using bitmaps for that. Moreover =E2=80=94 RAID-10 was the most I/O =
active
>> comparing to others, AFAIR.
>
> Unfortunately vague statements about "it was obvious" or "AFAIR" don'=
t really
> help in analysing a situation to find any bugs.
> I can only really work with concrete facts. =C2=A0Without them I cann=
ot help.

   Well, than probably you could tell me how one does find out whether
recovery uses WIB, or it doesn't? :-) I mean aside from vague
estimating based on watching re-sync progressing and considering
overall time it finally took to complete.

>> =C2=A0 =C2=A0P. s. Oh, and BTW, I see 2.6.18 supplied by RedHat stil=
l has the
>> bug causing kernel panic when using WIB -- couldn't you please point
>> out is it due to they're missing some important bugfix you made late=
r?
>
> I have no time or interest for submiting bug reports to distros that =
I don't
> use. =C2=A0If the presence of the bug concerns you, I suggest you rep=
ort it.

   I thought you could have some recollections bout this rather nasty
behavior. It has nothing to do with bug-reports for RedHat since
vanilla 2.6.18 for sure has the same bug, and hopefully it has been
fixed in later releases -- that was the only thing I was asking you
about. But your competent suggestions are also appreciated, of course.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
