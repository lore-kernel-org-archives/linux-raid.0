From: Nix <nix@esperi.org.uk>
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Date: Wed, 05 Dec 2007 19:29:36 +0000
Message-ID: <87tzmxym73.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
	<Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "1 Dec 2007 12:10:25 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On 1 Dec 2007, Jan Engelhardt uttered the following:

>
> On Dec 1 2007 06:19, Justin Piszcz wrote:
>
>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>> you use 1.x superblocks with LILO you can't boot)
>
> Says who? (Don't use LILO ;-)

Well, your kernels must be on a 0.90-superblocked RAID-0 or RAID-1
device. It can't handle booting off 1.x superblocks nor RAID-[56]
(not that I could really hope for the latter).

But that's just /boot, not everything else.

>>
>> Not using ANY initramfs/initrd images, everything is compiled into 1 
>> kernel image (makes things MUCH simpler and the expected device layout 
>> etc is always the same, unlike initrd/etc).
>>
> My expected device layout is also always the same, _with_ initrd. Why? 
> Simply because mdadm.conf is copied to the initrd, and mdadm will 
> use your defined order.

Of course the same is true of initramfs, which can give you the 1 kernel
image back, too. (It's also nicer in that you can autoassemble
e.g. LVM-on-RAID, or even LVM-on-RAID-over-nbd if you so desire.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
