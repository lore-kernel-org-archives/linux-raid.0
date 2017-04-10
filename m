From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Level change from 4 disk RAID5 to 4 disk RAID6
Date: Mon, 10 Apr 2017 06:41:08 +0100
Message-ID: <58EB1AF4.5010005@youngman.org.uk>
References: <20170408214239.GF10267@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170408214239.GF10267@lars-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: LM <linux-raid@moellendorf.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/04/17 22:42, LM wrote:
> Hi,
> 
> I have a 4 disk RAID5, the used dev size is 640.05 GB. Now I want to
> replace the 4 disks by 4 disks with a size of 2TB each.
> 
> As far as I understand the man page, this can be achieved by replacing
> the devices one after another and for each device rebuild the degraded
> array with:
> 
>    mdadm /dev/md0 --add /dev/sdX1

Do you have a spare SATA port or whatever your drives are. If so, then
use the --replace option to mdadm, don't fail then add. You're risking a
drive failure taking out your array - not a good move.

And if you don't have a spare port, $20 for a PCI card or whatever is a
good investment to keep your data safe.

Have a look at the raid wiki - it tries to be a bit more verbose and
easily comprehensible than the man page.

Cheers,
Wol
