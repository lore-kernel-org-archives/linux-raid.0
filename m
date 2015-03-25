From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 16:22:46 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se>
References: <5512D21E.1010506@sinno.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5512D21E.1010506@sinno.net>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Sinno <sinno@sinno.net>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

On Wed, 25 Mar 2015, Scott Sinno wrote:

>     JBOD controller failed this morning - we've replaced it, and all
> drives are being presented to the system again, however 'mdadm' refuses
> to assemble the ARRAY.  I've tried assembling with '--force' flags but
> it still won't...any help most appreciated.  I'm guessing I'll need to
> recreate with '--assemble-clean'

I would recommend you to not do that unless there is no other way out.

Please post dmesg output from the --assemble --force attempt, it might 
contain reason why the assembly was unsuccessful.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
