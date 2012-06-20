From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Wed, 20 Jun 2012 10:49:32 +0800
Message-ID: <CA+sTkh7=QrRyq23g=NDjOPLBfJRw8NFaQCPJc1JoDRa893_9oA@mail.gmail.com>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
 <20120527220007.64fb230b@notabene.brown> <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
 <20120528114550.417ae379@notabene.brown> <CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
 <20120528125436.69e847ca@notabene.brown> <CA+sTkh5wn0UaUb51+tcNegCooi5cUdVi08qQ5Z2RTk4j5Wk2qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh5wn0UaUb51+tcNegCooi5cUdVi08qQ5Z2RTk4j5Wk2qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 May 2012 12:03, Igor M Podlesny <for.poige+lsr@gmail.com> wrote:
> On 28 May 2012 10:54, NeilBrown <neilb@suse.de> wrote:
> [...]
>> The best indicator is total time that it takes (which can probably b=
e
>> extracted from logs as start and end are logged). =C2=A0Divide that =
into size of a
>> device to get average MB/sec. =C2=A0If the bitmap was used, that wil=
l normally be
>> much less the best throughput of the device.
>
> =C2=A0 That's exactly why I am stating it didn't use WIBs 2 times of =
3. It
> went resyncing from beginning till the end -- I had my finger on its
> pulse. :)
>
> =C2=A0 I can't promise (due to popular "lack of time" disease, yeah),=
 but
> if I'll get on it using VirtualBox or real environment [Lord forbid
> :)] once again, I'll let you know, sure.

   Here it is: http://pastie.org/4118133

   =E2=80=94 3.4.2-rt10 went suspend ok for 2 times, the 3rd it didn't.
Reboot, resync, no bitmaps use.

   And, BTW, it's rather slow in despite of having max. stripe_cache_si=
ze set.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
