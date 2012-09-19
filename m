From: Markus Irle <tha.bear@gmail.com>
Subject: Re: Wrong array size detected after reboot
Date: Wed, 19 Sep 2012 20:34:11 +0200
Message-ID: <CAFEwywbuH1689UStqoGOsvAh_X9afCpojKouY=Po5sXFGDFutw@mail.gmail.com>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
	<CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
	<20120919114202.0ad6355b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919114202.0ad6355b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neal,

On Wed, Sep 19, 2012 at 3:42 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 16 Sep 2012 01:32:06 +0200 Markus Irle <tha.bear@gmail.com> wrote:
>
>> I'm running 3.2 (3.2.0-31-generic, latest in current Ubuntu release 12.04) now.
>
> Sorry, I got that wrong.
> That commit is the one that introduced the bug.
>
> It's fixed by 667a5313ecd7308d which will be in 3.6, and is being
> back-ported to most -stable kernels, thought it doesn't seem to have arrived
> in any yet.
>
> Maybe you can ask Ubuntu to provide a kernel containing that commit?
> Or compile your own?
>
> Or find a kernel older than 3.2...

Ok, I'm a bit confused.

I was running 2.6.38 when I replaced the drives and grew the array.
Apparently growing went fine, because I was using the array for a
couple of weeks. But it didn't write the correct metadata (0.90), thus
reassembling after boot fails (or rather is the wrong size).

I tried booting with 3.0.0, 3.2.0 and 3.5.0 with exactly the same results.

I feel that no matter what kernel, as long as the metadata's wrong, I
can't assemble it correctly, correct?

Cheers,
Marks.
