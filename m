From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQgUkFJRDUtYXNraW5nIGZvciBz?=
 =?UTF-8?B?b21lIGFzc2lzdGFuY2U=?=
Date: Sun, 24 Apr 2011 03:12:54 +0100
Message-ID: <4DB38726.2090805@anonymous.org.uk>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>	<ioq2b8$3rl$1@dough.gmane.org>	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>	<20110422125734.1a68a736@notabene.brown>	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>	<20110423074411.78fef94f@notabene.brown>	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>	<20110423184824.55ee7893@notabene.brown>	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>	<20110424075101.6763309f@notabene.brown>	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>	<4DB370E1.5030602@anonymous.org.uk> <BANLkTikvevtAipmEtNEGdzG4rfVeOpbLxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikvevtAipmEtNEGdzG4rfVeOpbLxQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/2011 02:49, John Valarti wrote:
[...]
> This is looking gloomy now.

No it isn't!

> There definitely is NO mdadm.conf
> I checked.
> I used "find"

OK, that's fine - I didn't really expect there to be, unless you were 
using an emergency shell half-way through booting, in which case if 
there was one it might have been wrong since you've had to remove drives.

[...]
> mdadm -Esvv /dev/sd[abc]2:
>    mdadm: --examine/-E cannot be given with -w

That was the letter v twice, not the letter w - and I didn't mean you to 
specify any devices, just `mdadm -Esvv` on its own.

>> Please also try `mdadm --assemble --scan --verbose` and post the result.
> HERE:
> mdadm: /dev/sda2 not identified in config file.
> mdadm: /dev/sdb2 not identified in config file.
> mdadm: /dev/sdc2 not identified in config file.

Again, I didn't mean you to specify any devices, just exactly `mdadm 
--assemble --scan --verbose` on its own.

I'm not quite sure where you are but your timezone is -0600 while mine 
is +0100, it's gone 3 in the morning, so I'm going to bed now. Neil 
Brown is +1000 so it's Easter Sunday for him, which makes me think it's 
unlikely you'll see a reply from him today/tomorrow. Just stay calm and 
don't panic, we'll get there.

Cheers,

John.
