From: CaT <cat@zip.com.au>
Subject: Re: 2+ raid sets, sata and a missing hd question
Date: Wed, 15 Feb 2006 21:02:56 +1100
Message-ID: <20060215100256.GE8282@zip.com.au>
References: <20060215024521.GD8282@zip.com.au> <20060215065028.GA2452@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060215065028.GA2452@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 15, 2006 at 07:50:28AM +0100, Luca Berra wrote:
> On Wed, Feb 15, 2006 at 01:45:21PM +1100, CaT wrote:
> >Seeing as how SATA drives can move around if one removes one from a set
> >(ie given sda, sdb, sdc, if sdb was removed sdc drops to sdb) would md6
> >come back up without problems if I were to remove either sda or sdb.
> 
> if you configured mdadm correctly, you will have no problem :)
> 
> hint
> echo DEVICE partitions >> /etc/mdadm.conf
> mdadm -Esc partitions | grep ARRAY>> /etc/mdadm.conf

So the md5 array will reconstruct itself after initial bootup where the
kernel reconstructs the raid1 (as well as it can) for booting?

> >All md partitions are of type fd (Linux raid autodetect).
>
> this is surprisingly not at all relevant

Awww. But I like it when the kernel just, well, does it all and makes it
all ready. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
