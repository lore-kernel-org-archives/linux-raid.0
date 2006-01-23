From: Ville Herva <vherva@vianova.fi>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 14:54:20 +0200
Message-ID: <20060123125420.GE1686@vianova.fi>
References: <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <20060120183621.GA2799@redhat.com> <20060120225724.GW22163@marowsky-bree.de> <20060121000142.GR2801@redhat.com> <20060121000344.GY22163@marowsky-bree.de> <20060121000806.GT2801@redhat.com> <20060121001311.GA22163@marowsky-bree.de> <20060123094418.GX2801@redhat.com>
Reply-To: vherva@vianova.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060123094418.GX2801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>, Neil Brown <neilb@suse.de>, Phillip Susi <psusi@cfl.rr.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Mon, Jan 23, 2006 at 10:44:18AM +0100, you [Heinz Mauelshagen] wrote:
> > 
> > I use the regularly to play with md and other stuff...
> 
> Me too but for production, I want to avoid the
> additional stacking overhead and complexity.
> 
> > So I remain unconvinced that code duplication is worth it for more than
> > "hark we want it so!" ;-)
> 
> Shall I remove you from the list of potential testers of dm-raid45 then ;-)

Heinz, 

If you really want the rest of us to convert from md to lvm, you should
perhaps give some attention to thee brittle userland (scripts and and
binaries).

It is very tedious to have to debug a production system for a few hours in
order to get the rootfs mounted after each kernel update. 

The lvm error messages give almost no clue on the problem. 

Worse yet, problem reports on these issues are completely ignored on the lvm
mailing list, even when a patch is attached.

(See
 http://marc.theaimsgroup.com/?l=linux-lvm&m=113775502821403&w=2
 http://linux.msede.com/lvm_mlist/archive/2001/06/0205.html
 http://linux.msede.com/lvm_mlist/archive/2001/06/0271.html
 for reference.)

Such experience gives an impression lvm is not yet ready for serious
production use.

No offense intended, lvm kernel (lvm1 nor lvm2) code has never given me
trouble, and is probably as solid as anything. 


-- v -- 

v@iki.fi

PS: Speaking of debugging failing initrd init scripts; it would be nice if
the kernel gave an error message on wrong initrd format rather than silently
failing... Yes, I forgot to make the cpio with the "-H newc" option :-/.
