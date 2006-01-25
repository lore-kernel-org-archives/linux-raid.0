From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: multiple Sata SATAII 150, TX4 - how to tell which drive is
 which?headaches galore!
Date: Wed, 25 Jan 2006 06:51:51 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0601250637400.14030@shaka.acc.umu.se>
References: <43D62360.5060001@dgreaves.com>  <20060124161043.e90064b0@ted.secure-tunnel.com>
 <fd8d0180601240912g41b5d645s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601240912g41b5d645s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 24 Jan 2006, Francois Barre wrote:

> So my (real) question would be :
> - how much a drive consumes ? how long can it be on diet ?
> and, on top of this :
>
> Is it possible to make the drives turn slower ? To make the heads move 
> slower ? That would be my dream. No more heat, a 10mA consumption, no 
> more noise...

Some manufacturers do produce documentation regarding this:

http://www.hitachigst.com/tech/techlib.nsf/products/Deskstar_7K250

It is the "Specification - OEM" document[s] that are interesting, in my 
case lately: "Deskstar 7K250 Specification v1.6 (Serial ATA)"

On page 27 you have "Table 21: Power supply of current models" where you 
can read the power consumption of a drive during various kinds of load 
(startup, idle, random r/w, sleep).

Here you also can see that the "Silent" mode makes the drive use 8.5W 
instead of 10.6W under "Random R/W Average" load. Not that I know how to 
activate "Silent" mode from Linux, but I expect the document to tell you 
what bits you should send over the cable.

I suspect other manufacturers have similar documents, but I don't know if 
they are public or how to find them. Some pointing and clicking on 
websites will probably tell you what you need for your drives.

/Mattias Wadenstein
