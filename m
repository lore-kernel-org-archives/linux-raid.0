From: Yanggun <yang.geum.seok@gmail.com>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sun, 11 Dec 2005 23:29:23 +0900
Message-ID: <ee0ae26a0512110629u24a32a2fw@mail.gmail.com>
References: <20051128102824.14498.patches@notabene>
	 <1051127234104.14937@suse.de>
	 <ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
	 <17306.31969.240202.416327@cse.unsw.edu.au>
	 <ee0ae26a0512092350k43b6dc8l@mail.gmail.com>
	 <17306.35737.880103.939683@cse.unsw.edu.au>
	 <ee0ae26a0512100010v4d93d107k@mail.gmail.com>
	 <17306.50617.458648.8740@cse.unsw.edu.au>
	 <ee0ae26a0512110504y63589bck@mail.gmail.com>
	 <439C344F.9020408@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <439C344F.9020408@ucolick.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did not find involved part with this in the document.

I am sorry, inform it is what section.

2005/12/11, Patrik Jonsson <patrik@ucolick.org>:
> hello,
>
> Perhaps this can answer some questions:
>
> http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html
>
> cheers,
>
> /Patrik
>
> Yanggun wrote:
> > Thank you very much.
> >
> > Can you inform it is what difference technologically?
> >
> > Yanggun
> >
> > 2005/12/10, Neil Brown <neilb@suse.de>:
> >
> >>On Saturday December 10, yang.geum.seok@gmail.com wrote:
> >>
> >>>Should I do format after make RAID-1(/dev/md0) device?
> >>
> >>Yes.  format (mkfs) must come AFTER make RAID1 (mdadm -C).
> >>
> >>>After I format disks(/dev/sda1, /dev/sdb1), do not you compose to
> >>>RAID-1?
> >>
> >>Don't format sda1 or sdb1.  Compose the RAID-1 first, and then format
> >>md0.
> >>
> >>NeilBrown
> >>
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > !DSPAM:439c3231294002003030161!
> >
>
>
>
