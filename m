From: antlists <antlists@youngman.org.uk>
Subject: Re: Recovering From RAID5 Failure
Date: Wed, 22 Apr 2020 00:06:30 +0100
Message-ID: <3e3eb845-bd41-1b7a-6d31-2c13dca612b0@youngman.org.uk>
References: <CAM++EjGaFBh8ZChnyY0p=du0CKFT1WVikSNYyUUcJhuKwQf4sQ@mail.gmail.com>
 <CAAMCDeegCE4x26L4OYttiABxvxiu4qYykAo-b-53G-qW8Ua1Hw@mail.gmail.com>
 <CAM++EjHie1FFZ7y-VveWBSQs2TW=PkD+-QXKxK_pAON-GrcRcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM++EjHie1FFZ7y-VveWBSQs2TW=PkD+-QXKxK_pAON-GrcRcQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Leland Ball <lelandmball@gmail.com>, Roger Heflin <rogerheflin@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/04/2020 17:55, Leland Ball wrote:
> Thanks Roger, I appreciate your help and quick reply!
> 
> Two of the disks (sda, sdb) were able to return
>      # smartctl --all /dev/sdX
> just fine, but sdc and sdd returned very little, so I dug a bit deeper with
>      # smartctl -d ata -T permissive --all /dev/sdX
> 
> The results are in the pastebin: https://pastebin.com/yWJTPvBa
> It looks like only sdd has an error count. I would love to get this up
> long enough to recover at least a portion of the data, which isn't
> backed up elsewhere.
> 
PLEASE don't use pastebin and places like that. Just attach them to the 
email - they're plain text and aren't that big.

I looked up the model number on google - it's a Caviar Green. While I 
don't know that model, the fact it's a Green rings alarm bells. And I 
can find no mention of ERC - also a red light.

Can you get the disks out of the NAS and try to assemble the array on an 
up-to-date computer? Can you ddrescue sdd? The lack of ERC is very 
dangerous with parity raid.

Cheers,
Wol
