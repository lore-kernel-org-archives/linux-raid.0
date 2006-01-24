From: Francois Barre <francois.barre@gmail.com>
Subject: Re: multiple Sata SATAII 150, TX4 - how to tell which drive is which?headaches galore!
Date: Tue, 24 Jan 2006 18:12:50 +0100
Message-ID: <fd8d0180601240912g41b5d645s@mail.gmail.com>
References: <43D62360.5060001@dgreaves.com>
	 <20060124161043.e90064b0@ted.secure-tunnel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060124161043.e90064b0@ted.secure-tunnel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/1/24, Shawn Usry <shawn@joebacardi.com>:
> Hmm..that brings up an interesting question -
>
> Could/would/should a lack of sufficient power to the system, cause disk errors to show up, especially under high I/O?
>
> Anyone with experience in this?
>

Of course boy, and I've seen some.
Working on a proto based on a Via Epia 10k (Nehemiah), with a
home-brew power supply and a couple of pelletier modules, I had
problems with 2 IDE drives that were difficult to identify :
- spining was quite a long process, but went always ok (drives had
trouble to get to full speed, took 10secs for them to warm up).
- at heavy load, random crash (and you know how ide crashes). After a
long study, it came that the PSU voltage drop down for 12V (at 10.8V,
box crashes, net log says).

So my (real) question would be :
- how much a drive consumes ? how long can it be on diet ?
and, on top of this :

Is it possible to make the drives turn slower ? To make the heads move slower ?
That would be my dream. No more heat, a 10mA consumption, no more noise...
