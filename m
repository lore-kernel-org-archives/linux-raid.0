From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Mon, 19 Mar 2007 17:13:19 +0100
Message-ID: <1174320799.5044.21.camel@localhost.localdomain>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
	 <200703170909.13869.sr@denx.de>
	 <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com>
	 <200703171943.27465.sr@denx.de>
	 <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Stefan Roese <sr@denx.de>, linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org
List-Id: linux-raid.ids

BTW folks. Would it be hard to change your spe_ prefixes to something
else ? There's already enough confusion between the freescale SPE unit
and the cell SPEs :-)

(such confusion is annoying when grepp'ing for code that might touch a
given functionality for example).

Cheers,
Ben.


