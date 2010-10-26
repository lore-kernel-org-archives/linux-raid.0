From: Neil Brown <neilb@suse.de>
Subject: Re: MD RAID1 deadlock on failed disk
Date: Wed, 27 Oct 2010 10:56:15 +1100
Message-ID: <20101027105615.13ca3cd8@notabene>
References: <0AFDQ6P11@briare1.fullpliant.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0AFDQ6P11@briare1.fullpliant.org>
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Oct 2010 00:18:25 GMT
Hubert Tonneau <hubert.tonneau@fullpliant.org> wrote:

> 2.6.32.24 kernel worked fine.

Is this repeatable.
i.e. every time you pull a device on a 2.6.35.7 kernel it hangs?

If you can reproduce it, could you
   echo t > /proc/sysrq-trigger

and post the output that is written to the kernel log.

Thanks,
NeilBrown

> 
> Hubert Tonneau wrote:
> >
> > Hi,
> > 
> > The configuration is:
> > Perc H200 controler configured with no RAID (mpt2sas driver),
> > 2 SATA disks (sda and sdb),
> > Linux MD Sofware RAID1 (md0),
> > stock Linux 2.6.35.7 kernel.
> > 
> > I hotunplug the second (sdb) disk, and the result is:
> > . as expected, I can read sda device,
> > . as expected, any read to sdb device fails,
> > . unexpectedly, and read to md0 never returns.
> > 
> > No oops or thing like that in the kernel log.
> > I did not try the same with other kernel releases.
> > 
> > Regards,
> > Hubert Tonneau
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

