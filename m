From: Wolfgang Denk <wd@denx.de>
Subject: Re: [sucess] upgrading LSI SAS9211-8i fw IR->IT
Date: Mon, 06 Nov 2017 21:15:56 +0100
Message-ID: <20171106201556.C02DA120495@gemini.denx.de>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au> <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au> <34e5cc74-2cb2-5059-0e11-8f26a8bee223@eyal.emu.id.au> <31706ffc-3a81-b844-261e-a84dd8c01deb@fnarfbargle.com> <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Eyal,

In message <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au> you wrote:
>
> (I had many disk failures/replacements in the 4 years life of this array).

Reading this makes me wonder if you checked your environment for
other influences.  there must be some reason for an exceptional high
number of failures.

I remeber we also had a nighmare of disk errors in the rack in the
2nd floor of our building - which disappeared after moving the rack
into the basement.  I can't prove it, but I blame it on vibrations.
We have a heavy traffic train line less than 50 meters away, and
disks (classic, magnetic ones) definitely do not like vibrations -
see [1].  Maybe you have other influences you did not check for yet?

[1] https://www.youtube.com/watch?v=tDacjrSCeq4

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Speculation is always more interesting than facts.
                                    - Terry Pratchett, _Making_Money_
