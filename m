From: Nix <nix@esperi.org.uk>
Subject: Re: below 10MB/s write on raid5
Date: Thu, 14 Jun 2007 00:55:14 +0100
Message-ID: <87hcpb2yvx.fsf@hades.wkstn.nix>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
	<Pine.LNX.4.64.0706110847380.31708@p34.internal.lan>
	<200706111528.11828.Dexter.Filmore@gmx.de>
	<Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
	<87tzteku45.fsf@hades.wkstn.nix>
	<Pine.LNX.4.64.0706112134510.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706112134510.5806@gheavc.wnzcbav.cig> (Jon Nelson's message of "12 Jun 2007 03:35:40 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12 Jun 2007, Jon Nelson told this:
> On Mon, 11 Jun 2007, Nix wrote:
>
>> On 11 Jun 2007, Justin Piszcz told this:
>> loki:~# time dd if=/dev/md1 bs=1000 count=502400 of=/dev/null
>> 502400+0 records in
>> 502400+0 records out
>> 502400000 bytes (502 MB) copied, 16.2995 s, 30.8 MB/s
>> 
>> loki:~# time dd if=/dev/raid/usr bs=1000 count=502400 of=/dev/null
>> 502400+0 records in
>> 502400+0 records out
>> 502400000 bytes (502 MB) copied, 18.6172 s, 27.0 MB/s
>
> And what is it like with 'iflag=direct' which I really feel you have to 
> use, otherwise you get caching.

I have little enough memory on this box that caching is really not
significant :)

With iflag=direct I get, um,

loki:/var/log# time dd if=/dev/md1 bs=1000 count=502400 of=/dev/null iflag=direct
dd: reading `/dev/md1': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0324791 s, 0.0 kB/s

real    0m0.085s
user    0m0.000s
sys     0m0.000s

so not exactly ideal.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
