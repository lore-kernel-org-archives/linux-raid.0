From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.19.2, cp 18gb_file 18gb_file.2 = OOM killer, 100% reproducible
Date: Sun, 21 Jan 2007 11:48:07 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701211146530.15334@p34.internal.lan>
References: <Pine.LNX.4.64.0701201516450.3684@p34.internal.lan>
 <3aa654a40701201245s72b2f76hc70ddd94b70ba99c@mail.gmail.com>
 <Pine.LNX.4.64.0701201602570.4910@p34.internal.lan> <20070121155219.GA7413@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070121155219.GA7413@amd64.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: thunder7@xs4all.nl
Cc: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 21 Jan 2007, thunder7@xs4all.nl wrote:

> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date: Sat, Jan 20, 2007 at 04:03:42PM -0500
> > 
> > 
> > My swap is on, 2GB ram and 2GB of swap on this machine.  I can't go back 
> > to 2.6.17.13 as it does not recognize the NICs in my machine correctly and 
> > the Alsa Intel HD Audio driver has bugs etc, I guess I am stuck with 
> > 2.6.19.2 :(
> > 
> Well, if you can't go back, you could always test 2.6.20-rc5. That's why
> it's out there :-) It can't be any worse!
> 
> Good luck,
> Jurriaan
> -- 
> It might look like I'm doing nothing, but at the cellular level I'm really
> quite busy.
> 	Hans Haas
> Debian (Unstable) GNU/Linux 2.6.20-rc5 2x2011 bogomips load 1.97
> the Jack Vance Integral Edition: http://www.integralarchive.org
> 

The HDD temp bug -- OK, nice.

What about all of the changes with NAT?  I see that it operates on 
level-3/network wise, I enabled that and backward compatiblity support as 
well, but when my iptables rules kick in, it says no such driver/etc for 
`nat'-- is there a new target for iptables now or did I miss a kernel 
option?

Justin.
