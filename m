From: Gordon Henderson <gordon@drogon.net>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 19:14:06 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310281910090.25548@unicorn.drogon.net>
References: <Pine.LNX.4.44.0310281327090.8137-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310281327090.8137-100000@redhat1.mmaero.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Oct 2003 jlewis@lewis.org wrote:

> On Tue, 28 Oct 2003, maarten van den Berg wrote:
>
> > Promise cards do suck somewhat -albeit I use them- but what else is there ?
> > The highpoint-equipped cards are even more sucky in many cases.
>
> What about Adaptec's IDE/ATA versions of their DPT RAID controllers?
> AFAIK, they even use the same dpt driver.

Who knows. I've just tried to swap the 2 promise cards for 2 highpoint
cards - with fairly disastrous results )-: It booted, recognised the 4
disks (hde,g,i,k) but then started to whinge about DMA errors and general
badness, so put the promise cards back in and it's now hapilly rebuilding
the raid arrays.

Maybe it's having 2 promise (or highpoint) cards? I had one highpoint card
in another PC for a few days and it was performing well...

It's very annoying, whatever it is, and unfortunately I don't have the
resources or time to try to really get to the bottom of this )-:

Gordon
