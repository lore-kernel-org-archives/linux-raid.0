From: "Bernd Schubert" <Bernd.Schubert@tc.pci.uni-heidelberg.de>
Subject: Re: what is /dev/.static/dev/md0 ???
Date: Mon, 27 Jun 2005 10:58:13 +0200
Message-ID: <20050627085813.GB14246@tc.pci.uni-heidelberg.de>
References: <200506261422.28250.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200506261422.28250.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mitchell,


[...]

> (who ??? knows what the hell is going on with udev here....)
> 
[...]
> 
> My question:
> 
> what the heck is  
> devices=/dev/.static/dev/hdb1

/dev/.static should be bindmounted your old, pre udev/tmpfs mounted /dev
directory. AFAIK, udev takes it as sample directory to create the proper 
device names.
Don't ask me why udev sometimes works and sometimes not. After shortly
trying it last year on our sever systems, I quickly decided to better
not to use it there. On our diskless clients it is really neccessary, but
also has *sometimes* issues there, e.g. on about 5 of 45 clients
reboots, it forgets to create /dev/pts on those 5 clients.

Cheers,
	Bernd
