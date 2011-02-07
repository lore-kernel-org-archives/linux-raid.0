From: Martin Cracauer <cracauer@cons.org>
Subject: Re: Periodic RebuildStarted event
Date: Mon, 7 Feb 2011 18:59:09 -0500
Message-ID: <20110207235909.GA2142@cons.org>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com> <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com> <20110207234411.GA93362@cons.org> <AANLkTimBTE1uutF3ZsjVTFsBn-AOSTJ8Oa=Y1dprtHxc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimBTE1uutF3ZsjVTFsBn-AOSTJ8Oa=Y1dprtHxc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roberto Spadim wrote on Mon, Feb 07, 2011 at 09:52:34PM -0200: 
> i don?t know if exists, but maybe a internal mdadm command to check
> array (if have mirrors or ecc/checksum) with a limited speed (mb/s)
> read operation could help with periodic check (instead resync)

I don't experience performance problems from this.  Linux md seems to
be very good at putting the sync at a backburner when there is real
activity.  Just today I benchmarked an array that was in progress of
building a raid5 (initial sync).  Left most of the cycles to the
benchmark and took endless.  That should be configureable, too (for
those who want the sync done with priority but can't kill activity),
but anyway my concern isn't performance.

Martin

> 2011/2/7 Martin Cracauer <cracauer@cons.org>:
> > I just got through the RebuildStarted event which seems to be
> > monthly. ?This is being triggered by my Debian config, but before I
> > nuke it I'd like to know a little more.
> >
> > If a real disk error happens during this rebuild on a raid5, would the
> > disk go into regular degraded mode or would it count as a double
> > fault?
> >
> > I also noticed that recently all the checks for all the arrays happen
> > simultaneously. ?That's bad because most of them share the same
> > physical disks. ?Am I imagining this or was the system smart enough to
> > do them one after another until recently?
> >
> > Do you do period checks? I get lots of device mismatches reported but
> > apparently that's normal if there's write activity. ?The whole thing
> > sound contra-productive to me and might panic new users.
> >
> > Martin
> > --
> > %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> > Martin Cracauer <cracauer@cons.org> ? http://www.cons.org/cracauer/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> Roberto Spadim
> Spadim Technology / SPAEmpresarial

-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
