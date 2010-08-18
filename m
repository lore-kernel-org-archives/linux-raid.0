From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: the true behavior of mdadm's raid-1 with regard to vertical
 parity and silent error detection/scrubbing- confirmation or feature
 request
Date: Wed, 18 Aug 2010 10:00:17 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008180955430.8562@uplift.swm.pp.se>
References: <4C6B59F6.5020001@silcon.com> <4C6B8F9D.50105@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6B8F9D.50105@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Brett L. Trotter" <brett@silcon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 Aug 2010, Michael Tokarev wrote:

> But to me, the question is if there's a real reason/demand of doing so.

ZFS does it and people who are paranoid about bit rot really want it. It 
gives more protection against memory errors etc, ie outside the drive when 
the bits are in transit from the drive thru 
cables/controllers/drivers/block subsystem etc. Of course it's not 
perfect, but it gives some added protection.

If the cost/benefit analysis holds up or not I don't know, because I don't 
know the complexity. Having a 64k stripe in md actually use 68 k on drive 
and store some checksum might make sense, but it doesn't give great 
granularity. Perhaps those 4k can be checksum per 4k within the 64k stripe 
block so that a fairly fine-granular error can be given, and also if there 
is parity information available it can be read and the problem corrected.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
