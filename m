From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Wed, 7 Jul 2010 17:51:54 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wrt7ijp3.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Jul 2010, Daniel Pittman wrote:

> No.  OTOH, the poor sysadmins version of the "disk identification light" is:
>
>    sudo dd if=/dev/sdFAIL of=/dev/null
>
> ...plus a pair of eyes.  FWIW.

Yeah, if the drive is failed or if I know what drive to access I have no 
problem identifying it (I can access the working array and see what drive 
slots blink and which don't, or try to access the failed drive). But I 
have right now no way to identify the drive on "ata14.00". I can from 
dmesg deduce that it's most likely /dev/sdj (by observing the order of 
things being identified), but I don't know for sure it seems.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
