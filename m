From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Sun, 30 Apr 2017 18:16:47 +0100
Message-ID: <59061BFF.2070503@youngman.org.uk>
References: <590117CD.1000009@tesco.net>
 <22785.65375.947842.648174@quad.stoffel.home>
 <5492628.c8B43Z4h0G@matkor-lenovo>
 <22786.16524.435313.304834@quad.stoffel.home> <87o9veje3v.fsf@esperi.org.uk>
 <20170430182134.0e8c6dc0@natsu> <87fugpkhap.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fugpkhap.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/04/17 17:10, Nix wrote:
> This is a one-off with tooling to manage it: from my perspective, I just
> kick off the autobuilders etc and they'll automatically use transient
> space for objdirs. (And obviously this is all scripted so it is no
> harder than making or removing directories would be: typing 'mktransient
> foo' to automatically create a dir in transient space and set up a bind
> mount to it -- persisted across boots -- in the directory' foo' is
> literally a few letters more than typing 'mkdir foo'.)

This sounds like me with tmpfs. Okay, mine don't persist across reboots,
but if it's in your build scripts, can't they create a tmpfs and do the
builds in that?

My system maxes out at 16GB ram, so twice ram per disk as swap gives me
32GB swap/disk by 2 disks gives me 64GB of swap for all my transient
stuff. Running gentoo, I need that space to build gcc, LO etc :-)

Cheers,
Wol
