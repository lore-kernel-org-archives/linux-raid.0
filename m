From: Hans Kristian Rosbach <hk@isphuset.no>
Subject: Re: multiple Sata SATAII 150, TX4 - how to tell which drive is
	which?headaches galore!
Date: Wed, 25 Jan 2006 09:33:17 +0100
Message-ID: <1138177997.28634.370.camel@linux>
References: <43D62360.5060001@dgreaves.com>
	 <20060124161043.e90064b0@ted.secure-tunnel.com>
	 <fd8d0180601240912g41b5d645s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601240912g41b5d645s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2006-01-24 at 18:12 +0100, Francois Barre wrote:
> Is it possible to make the drives turn slower ? To make the heads move slower ?
> That would be my dream. No more heat, a 10mA consumption, no more noise...

It is not possible to make the disk platters spin slower, since the
speed of the platters is what makes sure the heads don't touch the
platters.

It is possible to slow down head movement, either by hdparm or you can
set it permanently (until you change it again) with tools often
provided by the manufacturer.

-HK

