From: Christian Balzer <chibi@gol.com>
Subject: Re: RAID5 TRIM/DISCARD user land support (fstriim and mkfs)
Date: Mon, 10 Aug 2015 17:53:36 +0900
Message-ID: <20150810175336.5582e9fd@batzmaru.gol.ad.jp>
References: <20150810164657.75bae079@batzmaru.gol.ad.jp>
	<alpine.LRH.2.20.1508100824290.8849@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1508100824290.8849@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>
List-Id: linux-raid.ids

On Mon, 10 Aug 2015 08:28:39 +0000 (UTC) Holger Kiehl wrote:

> Hello,
> 
> On Mon, 10 Aug 2015, Christian Balzer wrote:
> 
> >
> > Hello,
> >
> > Debian system, tested both Wheezy and Jessie, thus 3.16 kernel with
> > backports.
> >
> > 8 SSD RAID5, of course with raid456.devices_handle_discard_safely set
> > to 1. I can re-mount it with discard w/o a problem:
> > ---
> > EXT4-fs (md4): re-mounted. Opts: stripe=112,data=ordered,discard
> > ---
> >
> > However fstrim whines about "FITRIM ioctl failed: Operation not
> > supported" and mkfs.ext4 unsurprisingly doesn't discard things when
> > invoked.
> >
> > The same HW/OS combo works fine with RAID10.
> >
> > When looking at the sysfs entries for that MD device the fact
> > that /sys/class/block/md4/queue/discard_zeroes_data is 0 doesn't
> > instill me with hope or confidence
> >
> > Now while the SSDs in question (Intel DC S3610s) don't really need TRIM
> > really would have liked them to be able to start with a clean slate so
> > to speak.
> >
> > Any insights?
> >
> Discard for raid456 has been disabled by default because some devices in
> some cases don't do what it says on the label.
> 
> You can enable it by setting the module parameter
> 
>     raid456.devices_handle_discard_safely=Y
> 
That's what I said I did in the 2nd sentence up there.

If it were unset, a kernel warning
"md/raid456: discard support disabled due to uncertainty."
would be issued during RAID startup/assembly.

Christian

> Ensure that your drives can handle discard safely.
> 
> Regards,
> Holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
