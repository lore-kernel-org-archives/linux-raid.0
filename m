From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 15:06:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310281506.32013.maarten@vbvb.nl>
References: <3F9DAD4C.3000002@verizon.net> <Pine.LNX.4.56.0310280749080.23689@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0310280749080.23689@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 09:26, Gordon Henderson wrote:
> On Mon, 27 Oct 2003, berk walker wrote:

> Good luck with your promise board (what type is it?) I've had a lot of
> problems with them (kernels 2.4.20-22) They seem to work, but under heavy
> load, I see processes getting stuck in "D" state (eg. nfsd or anything
> doing lots of disk IO) Most of the time they recover, but I've load a disk
> partition on more than one occasion (saved by raid, and it re-built OK
> after a reboot). I've seen this in 2 different servers and tried both
> Intel and AMD CPUs. Tonight I try a set of different PCI IDE controllers
> in one server to see if that helps it.

Promise cards do suck somewhat -albeit I use them- but what else is there ? 
The highpoint-equipped cards are even more sucky in many cases.

> It's hard to tell if it's a real hardware problem or a software one (the
> Promise driver being fairly new, patched in at 2.4.20, included in 2.4.22)

Ehm, what ???  You're probably talking about the driver for the fasttrack 
cards who are -in their own respect- raid cards. But if you use a 'plain' 
card like the ultra it's just used as an additional IDE channel. That has 
worked long long before 2.4.20 and it is what I use.  No sense in buying a 
pricey fasttrack if you're not going to use the raid but use the md tools 
instead.

Regards,
Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
