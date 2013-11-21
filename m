From: Phil Turmel <philip@turmel.org>
Subject: Re: unused space before data offset mismatch
Date: Wed, 20 Nov 2013 22:25:55 -0500
Message-ID: <528D7D43.3070708@turmel.org>
References: <528D118D.7090800@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528D118D.7090800@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: kustep <kustep@web.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/20/2013 02:46 PM, kustep wrote:
> Hello Everyone,
> 
> is there an option to specifiy the "Unused Space : before=...."
> Superblock information in mdadm -C ....?

I don't know about this, but ...

> My Raid crashed due to a controller error, but I was able to make the
> new superblock almost identical to the old one (using mdadm -C
> --assume-clean --level=6 --raid-devices=11 --chunk=256K --metadata=1.2
> --bitmap=None --size=195328588 --data-offset=128768 /dev/md0
> /dev/mapper/disk[cdefmbjkh] missing). Looking at mdadm --examine the

This almost certainly didn't do what you think--square brackets in the
shell don't maintain the order of the letters given.  The device order
actually given to mdadm would have been [bcdefhjkm].  The bracket
notation will also leave out devices that don't actually exist.  You
need to use curly braces with commas to maintain a specific order.

FWIW,

Phil
