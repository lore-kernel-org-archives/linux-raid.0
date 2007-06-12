From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 21:35:30 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706112134510.5806@gheavc.wnzcbav.cig>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110847380.31708@p34.internal.lan> <200706111528.11828.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan> <87tzteku45.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tzteku45.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Jun 2007, Nix wrote:

> On 11 Jun 2007, Justin Piszcz told this:
> > You can do a read test.
> >
> > 10gb read test:
> >
> > dd if=/dev/md0 bs=1M count=10240 of=/dev/null
> >
> > What is the result?
> >
> > I've read that LVM can incur a 30-50% slowdown.
> 
> FWIW I see a much smaller penalty than that.
> 
> loki:~# lvs -o +devices
>   LV           VG    Attr   LSize   Origin Snap%  Move Log Copy%  Devices
> [...]
>   usr          raid  -wi-ao   6.00G                               /dev/md1(50)
> 
> loki:~# time dd if=/dev/md1 bs=1000 count=502400 of=/dev/null
> 502400+0 records in
> 502400+0 records out
> 502400000 bytes (502 MB) copied, 16.2995 s, 30.8 MB/s
> 
> loki:~# time dd if=/dev/raid/usr bs=1000 count=502400 of=/dev/null
> 502400+0 records in
> 502400+0 records out
> 502400000 bytes (502 MB) copied, 18.6172 s, 27.0 MB/s

And what is it like with 'iflag=direct' which I really feel you have to 
use, otherwise you get caching.

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
