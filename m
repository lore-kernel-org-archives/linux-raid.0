From: Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Tue, 20 Mar 2007 06:39:06 +0100
Message-ID: <200703200639.07868.sr@denx.de>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <1174320799.5044.21.camel@localhost.localdomain> <1174359995.10827.10.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174359995.10827.10.camel@concordia.ozlabs.ibm.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: michael@ellerman.id.au
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org
List-Id: linux-raid.ids

On Tuesday 20 March 2007 04:06, Michael Ellerman wrote:
> On Mon, 2007-03-19 at 17:13 +0100, Benjamin Herrenschmidt wrote:
> > BTW folks. Would it be hard to change your spe_ prefixes to something
> > else ? There's already enough confusion between the freescale SPE unit
> > and the cell SPEs :-)
> >
> > (such confusion is annoying when grepp'ing for code that might touch a
> > given functionality for example).
>
> Please please please!

OK. Who can resist so much pleading. ;-)

Best regards,
Stefan
