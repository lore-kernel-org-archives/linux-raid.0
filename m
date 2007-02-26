From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Mon, 26 Feb 2007 15:15:45 +0100
Message-ID: <eruq2h$nvi$1@sea.gmane.org>
References: <45D89FF5.3020303@sauce.co.nz> <200702191426.16567.a1426z@gawab.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi <a1426z@gawab.com> wrote:
> Interesting link.  They seem to point out that smart not necessarily warns of  
> pending failure.  This is probably worse than not having smart at all, as it 
> gives you the illusion of safety.

If SMART gives you the illusion of safety, you didn't understand SMART.
SMART hints *only* the potential presence or occurence of failures in
the future, it does not prove the absence of such - and nobody ever said
it does. It would even be impossible to do that, though (which is easy
to prove by just utilizing an external damaging tool like a hammer).
Concluding from that that not having any failure detector at all is
better than having at least an imperfect one is IMHO completely wrong.


regards
   Mario
-- 
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

