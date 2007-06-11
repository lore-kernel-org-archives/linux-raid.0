From: Nix <nix@esperi.org.uk>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 23:24:10 +0100
Message-ID: <87tzteku45.fsf@hades.wkstn.nix>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
	<Pine.LNX.4.64.0706110847380.31708@p34.internal.lan>
	<200706111528.11828.Dexter.Filmore@gmx.de>
	<Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan> (Justin Piszcz's message of "11 Jun 2007 14:29:24 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Jun 2007, Justin Piszcz told this:
> You can do a read test.
>
> 10gb read test:
>
> dd if=/dev/md0 bs=1M count=10240 of=/dev/null
>
> What is the result?
>
> I've read that LVM can incur a 30-50% slowdown.

FWIW I see a much smaller penalty than that.

loki:~# lvs -o +devices
  LV           VG    Attr   LSize   Origin Snap%  Move Log Copy%  Devices
[...]
  usr          raid  -wi-ao   6.00G                               /dev/md1(50)

loki:~# time dd if=/dev/md1 bs=1000 count=502400 of=/dev/null
502400+0 records in
502400+0 records out
502400000 bytes (502 MB) copied, 16.2995 s, 30.8 MB/s

real    0m16.360s
user    0m0.310s
sys     0m11.780s

loki:~# time dd if=/dev/raid/usr bs=1000 count=502400 of=/dev/null
502400+0 records in
502400+0 records out
502400000 bytes (502 MB) copied, 18.6172 s, 27.0 MB/s

real    0m18.790s
user    0m0.380s
sys     0m14.750s


So there's a penalty, sure, accounted for mostly in sys time, but it's
only about 10%: small enough that I at least can ignore it in exchange
for the administrative convenience of LVM.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
