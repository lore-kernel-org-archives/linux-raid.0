From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Western Digital RE3: Raid Failure
Date: Sat, 5 Sep 2009 06:22:50 -0600
Message-ID: <200909050622.51020.tfjellstrom@shaw.ca>
References: <b9f8dfb10908270243u1213576cs7c5cbc743d637c1c@mail.gmail.com> <200909042153.23094.tfjellstrom@shaw.ca> <alpine.LFD.2.00.0909051312300.6478@sbhezbfg.of5.nffheflf.cev>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0909051312300.6478@sbhezbfg.of5.nffheflf.cev>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Butcher <linraid@assursys.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat September 5 2009, Alex Butcher wrote:
> On Fri, 4 Sep 2009, Thomas Fjellstrom wrote:
> > On Thu September 3 2009, you wrote:
> >> On Thu, 3 Sep 2009, Gabor Gombas wrote:
> >>> On Thu, Sep 03, 2009 at 11:14:45AM +0200, MOgWai46[Saurceful of
> >>> Secrets]
> >
> > wrote:
> >>>> This is the output of smartctl -a /dev/sdc:
> >>>> http://nopaste.com/p/aXwmnSEphb
> >>>
> >>>  5 Reallocated_Sector_Ct   0x0033   197   197   140    Pre-fail  Always
> >>>     -       24 [...]
> >>> 196 Reallocated_Event_Count 0x0032   197   197   000    Old_age  
> >>> Always -       3
> >>>
> >>> IMHO it's time to replace the drive. I think it also shows that TLER is
> >>> working just as expected: timing out when the recovery would have taken
> >>> too long.
> >>
> >> The drive has only been spinning for 1008 hours, or about 42 days. It's
> >> probably still under warranty, but I'd be surprised if WD (or any other
> >> vendor) will accept an RMA since it will probably pass all its
> >> diagnostic tests.
> >
> > I just returned a Seagate drive that passed all tests. But its
> > reallocated sector count was over 1500 (and climbing 10 or more per
> > hour). The support tech didn't have a problem with authorizing the RMA.
> > So if the problem gets bad enough, they SHOULD take the drive back, or at
> > least Seagate will.
> 
> Different circumstances; your drive's reallocated count was higher and
> consistently climbing.

Yeah, I did say "if the problem gets bad enough".

> Sectors go bad, drives have spares, drives with reallocated sectors aren't
> necessarily dead or about to die imminently, keep backups of files that are
> important to you in case a file occupies a sector that goes bad, RAID is
>  not backup.
> 
> >>> Gabor
> >>
> >> Alex
> 
> Best Regards,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
