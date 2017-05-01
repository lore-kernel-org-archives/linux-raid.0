From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Mon, 01 May 2017 21:12:54 +0100
Message-ID: <877f20jpyx.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk> <20170430182134.0e8c6dc0@natsu>
        <87fugpkhap.fsf@esperi.org.uk> <59061BFF.2070503@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59061BFF.2070503@youngman.org.uk> (Wols Lists's message of "Sun,
        30 Apr 2017 18:16:47 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Roman Mamedov <rm@romanrm.net>, John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30 Apr 2017, Wols Lists verbalised:

> On 30/04/17 17:10, Nix wrote:
>> This is a one-off with tooling to manage it: from my perspective, I just
>> kick off the autobuilders etc and they'll automatically use transient
>> space for objdirs. (And obviously this is all scripted so it is no
>> harder than making or removing directories would be: typing 'mktransient
>> foo' to automatically create a dir in transient space and set up a bind
>> mount to it -- persisted across boots -- in the directory' foo' is
>> literally a few letters more than typing 'mkdir foo'.)
>
> This sounds like me with tmpfs. Okay, mine don't persist across reboots,
> but if it's in your build scripts, can't they create a tmpfs and do the
> builds in that?

Even though I have 128GiB RAM, I don't want a tmpfs for everything
(though I use it for a lot, oh yes). Some of the transient stuff is
things like QEMU CoW disk images that I don't want to lose on every
reboot (though rebuilding them is not too annoying, it is not totally
ignorable either); other stuff is things like vapoursynth intermediates
which can easily exceed 500GiB, which are only ever read once but
nonetheless just won't fit.

-- 
NULL && (void)
