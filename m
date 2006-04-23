From: Nix <nix@esperi.org.uk>
Subject: Re: disks becoming slow but not explicitly failing anyone?
Date: Sun, 23 Apr 2006 14:38:21 +0100
Message-ID: <87d5f8s982.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.44.0604222039500.6786-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0604222039500.6786-100000@coffee.psychology.mcmaster.ca> (Mark Hahn's message of "23 Apr 2006 01:46:28 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Apr 2006, Mark Hahn said:
>                   some people claim that if you put a normal (desktop)
> drive into a 24x7 server (with real round-the-clock load), you should 
> expect failures quite promptly.  I'm inclined to believe that with 
> MTBF's upwards of 1M hour, vendors would not claim a 3-5yr warranty
> unless the actual failure rate was low, even if only running 8/24.

I've seen a lot of cheap disks say (generally deep in the data sheet
that's only available online after much searching and that nobody ever
reads) that they are only reliable if used for a maximum of twelve hours
a day, or 90 hours a week, or something of that nature. Even server
disks generally seem to say something like that, but the figure given is
more like `168 hours a week', i.e., constant use.

It still stuns me that anyone would ever voluntarily buy drives that
can't be left switched on (which is perhaps why the manufacturers hide
the info in such an obscure place), and I don't know what might go wrong
if you use the disk `too much': overheating?

But still it seems that there are crappy disks out there with very
silly limits on the time they can safely be used for.

(But this *is* the RAID list: we know that disks suck, right?)

-- 
`On a scale of 1-10, X's "brokenness rating" is 1.1, but that's only
 because bringing Windows into the picture rescaled "brokenness" by
 a factor of 10.' --- Peter da Silva
