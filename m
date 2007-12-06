From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Date: Thu, 6 Dec 2007 16:08:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712061607420.19266@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
 <87tzmxym73.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tzmxym73.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids


On Dec 5 2007 19:29, Nix wrote:
>>
>> On Dec 1 2007 06:19, Justin Piszcz wrote:
>>
>>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>>> you use 1.x superblocks with LILO you can't boot)
>>
>> Says who? (Don't use LILO ;-)
>
>Well, your kernels must be on a 0.90-superblocked RAID-0 or RAID-1
>device. It can't handle booting off 1.x superblocks nor RAID-[56]
>(not that I could really hope for the latter).

If the superblock is at the end (which is the case for 0.90 and 1.0),
then the offsets for a specific block on /dev/mdX match the ones for /dev/sda,
so it should be "easy" to use lilo on 1.0 too, no?
(Yes, it will not work with 1.1 or 1.2.)
