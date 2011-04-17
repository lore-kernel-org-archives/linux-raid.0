From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Sun, 17 Apr 2011 20:45:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104172042570.14027@uplift.swm.pp.se>
References: <4DA6CCFE.8020708@crc.id.au> <20110414185304.5bc1cca5@natsu> <4DA6F3B2.8080402@crc.id.au> <4DA7513C.5020505@hardwarefreak.com> <20110415105846.1c4ec630@natsu> <4DA8B91C.8050005@hardwarefreak.com> <20110416111554.09066e73@natsu>
 <4DA959E4.2080605@fnarfbargle.com> <4DA9FED8.2000308@hardwarefreak.com> <4DAA7E46.6040309@fnarfbargle.com> <4DAB3344.2090502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAB3344.2090502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Roman Mamedov <rm@romanrm.ru>, Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 17 Apr 2011, Stan Hoeppner wrote:

> The fact that the Russian with 5 cards purchased in Dubai could 
> routinely demonstrate this problem with 2 of 5 identical cards, and 
> never on the other 3, points directly to a board QC isue.  Again, if the 
> problem were a design flaw in the IC itself, all 5 cards would have 
> exhibited the problem.

I think you're missing the point.

A proper hardware design should detect errors in the chip, and should 
offline itself (or at least complain loudly). This is robustness in 
design, that if something goes wrong in the production process that QC 
doesn't find, card notices this and goes offline.

I personally have two of these controllers and they're working well, but I 
have to agree that it's very likely that these low-cost products are not 
as resilient to problems as the more expensive devices out there.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
