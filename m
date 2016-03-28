From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Looking to pick PCIe x4/x8 4+ SATA expansion card recommendation.
Date: Mon, 28 Mar 2016 22:03:27 +0100
Message-ID: <56F99C1F.2050107@youngman.org.uk>
References: <56F97B91.4070302@gmail.com>
 <22265.33776.226233.227426@quad.stoffel.home>
 <22265.34078.125691.255754@quad.stoffel.home> <56F98958.3020704@gmail.com>
 <22265.36590.539103.542573@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22265.36590.539103.542573@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/03/16 21:07, John Stoffel wrote:
> You do want to test booting from a broken RAID1 boot device.  When I
> recently did my big re-org, I found that to make it boot I had to move
> the working boot drive to the non-working slot, since of course the
> failed one was effectively /dev/first-drive and that's how grub needed
> to boot.

Your setup regime really should check that you install grub on ALL your
drives. Easier said than done though when adding new drives ... :-)

Cheers,
Wol
