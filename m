From: Nix <nix@esperi.org.uk>
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Date: Fri, 07 Dec 2007 07:30:08 +0000
Message-ID: <877ijrynb3.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
	<Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
	<87tzmxym73.fsf@hades.wkstn.nix>
	<Pine.LNX.4.64.0712061607420.19266@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712061607420.19266@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "6 Dec 2007 15:09:15 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On 6 Dec 2007, Jan Engelhardt verbalised:
> On Dec 5 2007 19:29, Nix wrote:
>>>
>>> On Dec 1 2007 06:19, Justin Piszcz wrote:
>>>
>>>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>>>> you use 1.x superblocks with LILO you can't boot)
>>>
>>> Says who? (Don't use LILO ;-)
>>
>>Well, your kernels must be on a 0.90-superblocked RAID-0 or RAID-1
>>device. It can't handle booting off 1.x superblocks nor RAID-[56]
>>(not that I could really hope for the latter).
>
> If the superblock is at the end (which is the case for 0.90 and 1.0),
> then the offsets for a specific block on /dev/mdX match the ones for /dev/sda,
> so it should be "easy" to use lilo on 1.0 too, no?

Sure, but you may have to hack /sbin/lilo to convince it to create the
superblock there at all. It's likely to recognise that this is an md
device without a v0.90 superblock and refuse to continue. (But I haven't
tested it.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
