From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Need some information and help on mdadm in order to support it
 on IBM z Systems
Date: Fri, 18 Apr 2008 11:46:23 +0200
Message-ID: <fu9qlp$iaj$1@ger.gmane.org>
References: <OF9FBFD1B1.E511C96F-ONC1257428.004472D1-C1257428.004493A0@de.ibm.com>
 <47FF7831.20707@tmr.com>
 <OF70B5DB7B.09FE2CC6-ONC125742B.0032A67D-C125742B.003CF42B@de.ibm.com>
 <4804F9FD.4070606@tmr.com>
 <OF759BAE37.32591658-ONC125742D.004F2D87-C125742D.00543FEE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jean-Baptiste Joret <JORET@de.ibm.com> wrote:
> the scenario actually involves simulating a hardware connection issue for 
> a few seconds and bring it back online. But once the hardware comes back 
> online it is still do not come back into the array an remains marked 
> "faulty spare". Moreover, if you then reboot, the mirror comes up and you 
> can mount it but it is degraded and my "faulty spare" is now removed:

This is just the normal way md deals with faulty components. And even
more: I personally don't know any (soft or hard) RAID solution that
would automatically try to re-add faulty components back to an array.
I personally would also consider such an automatic re-add a really bad
idea. There was a reason for the component to fail, you don't want to
touch it again without user intervention - it could make things far more
worse (blocking busses, reading wrong data etc.). A user who knows
better can of course trigger the RAID to touch it again - for md it's
just the way you described already: remove the faulty component from the
array and re-add it.

Being more "intelligent" regarding such an automatic re-add would
require a far deeper failure analysis to decide whether it would be safe
to try re-adding it or better leave it untouched. I don't know any
software yet that would be capable to do so.

Afaik, since a little while md contains one such automatism regarding
sector read errors where it automatically tries to re-write this sector
to the failing disk to trigger disk's sector-reallocation. I personally
even consider this behaviour quite dangerous, since there is no
guarantee that this read-error really occured due to a (quite harmless)
single-sector failure and thus, IMHO even there is a chance to make
things more worse by touching the failing disk again per default.


regards
   Mario
-- 
Computer Science is no more about computers than astronomy is about
telescopes.                                       -- E. W. Dijkstra

