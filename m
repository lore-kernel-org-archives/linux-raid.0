From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Tue, 26 Jun 2012 16:55:07 +0800
Message-ID: <CA+sTkh7D83jxxf79vmVPLyEU3iTNqqiPCMT=DBnAQtS6x-SD7g@mail.gmail.com>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
 <20120527220007.64fb230b@notabene.brown> <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
 <20120528114550.417ae379@notabene.brown> <CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
 <20120528125436.69e847ca@notabene.brown> <CA+sTkh5wn0UaUb51+tcNegCooi5cUdVi08qQ5Z2RTk4j5Wk2qA@mail.gmail.com>
 <CA+sTkh7=QrRyq23g=NDjOPLBfJRw8NFaQCPJc1JoDRa893_9oA@mail.gmail.com> <20120626161846.08489b0a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120626161846.08489b0a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 June 2012 14:18, NeilBrown <neilb@suse.de> wrote:
> On Wed, 20 Jun 2012 10:49:32 +0800 Igor M Podlesny <for.poige+lsr@gma=
il.com>
> wrote:
[=E2=80=A6]
>> =C2=A0 =C2=A0Here it is: http://pastie.org/4118133
>
> This doesn't appear to show the "start to end" that I suggested, just=
 10% to
> 30%, but it does suggest that the bitmap isn't speeding things up at =
all, at
> least for that part of the array... That is assuming you are talking =
about

   Well, I decided that's enough to be "pasted", but anyway, I can
assure you =E2=80=94 it took ~ 1 hour, as it was estimated, so yeah =E2=
=80=94 no use
of bitmap. For sure.

> md124. =C2=A0I note that md125 doesn't have a bitmap. =C2=A0Is that w=
hat you are
> referring to?

   Yeah, md125 is legacy RAID which is not being in use for a long
time, it's just hanging around till re-layout happens.
>
> The next thing to do would be to look at the bitmap immediately after=
 reboot
> to see how many bits are set. =C2=A0Maybe lots are set for some reaso=
n.
>
>>
>> =C2=A0 =C2=A0=E2=80=94 3.4.2-rt10 went suspend ok for 2 times, the 3=
rd it didn't.
>> Reboot, resync, no bitmaps use.
>>
>> =C2=A0 =C2=A0And, BTW, it's rather slow in despite of having max. st=
ripe_cache_size set.
>>
>
> A larger stripe cache isn't going to affect resync speed much (I thin=
k).
> 50MB/sec on each drive seems fairly good to me. =C2=A0What were you e=
xpecting?

   I see, thanks.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
