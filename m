From: Yanggun <yang.geum.seok@gmail.com>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sun, 11 Dec 2005 22:04:25 +0900
Message-ID: <ee0ae26a0512110504y63589bck@mail.gmail.com>
References: <20051128102824.14498.patches@notabene>
	 <1051127234104.14937@suse.de>
	 <ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
	 <17306.31969.240202.416327@cse.unsw.edu.au>
	 <ee0ae26a0512092350k43b6dc8l@mail.gmail.com>
	 <17306.35737.880103.939683@cse.unsw.edu.au>
	 <ee0ae26a0512100010v4d93d107k@mail.gmail.com>
	 <17306.50617.458648.8740@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17306.50617.458648.8740@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you very much.

Can you inform it is what difference technologically?

Yanggun

2005/12/10, Neil Brown <neilb@suse.de>:
> On Saturday December 10, yang.geum.seok@gmail.com wrote:
> >
> > Should I do format after make RAID-1(/dev/md0) device?
>
> Yes.  format (mkfs) must come AFTER make RAID1 (mdadm -C).
> >
> > After I format disks(/dev/sda1, /dev/sdb1), do not you compose to
> > RAID-1?
>
> Don't format sda1 or sdb1.  Compose the RAID-1 first, and then format
> md0.
>
> NeilBrown
>
