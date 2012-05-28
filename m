From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Mon, 28 May 2012 12:03:30 +0800
Message-ID: <CA+sTkh5wn0UaUb51+tcNegCooi5cUdVi08qQ5Z2RTk4j5Wk2qA@mail.gmail.com>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
 <20120527220007.64fb230b@notabene.brown> <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
 <20120528114550.417ae379@notabene.brown> <CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
 <20120528125436.69e847ca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120528125436.69e847ca@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 May 2012 10:54, NeilBrown <neilb@suse.de> wrote:
[...]
> The best indicator is total time that it takes (which can probably be
> extracted from logs as start and end are logged). =C2=A0Divide that i=
nto size of a
> device to get average MB/sec. =C2=A0If the bitmap was used, that will=
 normally be
> much less the best throughput of the device.

   That's exactly why I am stating it didn't use WIBs 2 times of 3. It
went resyncing from beginning till the end -- I had my finger on its
pulse. :)

   I can't promise (due to popular "lack of time" disease, yeah), but
if I'll get on it using VirtualBox or real environment [Lord forbid
:)] once again, I'll let you know, sure.

[...]
> 2.6.18 is a long time ago. =C2=A0I don't really have any recollection=
s - so many
> bugs, so many releases. =C2=A0I'm not even entirely sure what bug you=
 are
> referring to. =C2=A0I would probably have tagged any patch for it to =
be included
> in -stable, but I cannot be certain without looking more deeply.

   Okay, thanks, it gonna take some kind of bisecting I guess, then.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
