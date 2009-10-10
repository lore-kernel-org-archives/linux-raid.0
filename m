From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: NAS Remote Side of a Mirror
Date: Sat, 10 Oct 2009 08:28:00 -0600
Message-ID: <200910100828.00144.tfjellstrom@shaw.ca>
References: <39822.52296.qm@web38802.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39822.52296.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat October 10 2009, adfas asd wrote:
> --- On Sat, 10/10/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >     I'm not familiar with NX.  Why not
> > X11?
> 
> I tried to set up remote X a long time ago, but it was just too
>  problematic.  NX does essentially the same thing, and has built-in
>  security. (nomachine.com)  Works great, and is very fast.
> 
> > > I'm not about to use bloatware like NFS or Samba. And
> >
> > sshfs or an SSH
> >
> > > tunnel could not keep up the speeds I'd need. How do
> >
> > you suppose Qnap
> >
> >     Why do you say that?  From what I
> > have seen of your requirements, it
> > doesn't sound like you will require very much at all in the
> > way of speed on
> > your array.
> 
> Why do I say that?  Because they -are- bloatware, and an unnecessary fat
>  layer in the system, with all the potential for error and security breach
>  that implies.  iSCSI is the way, in the 21st century.

iSCSI is also bloatware you know. If you want something thin and light, try 
ATA Over Ethernet (AoE), or DRBD, or NBD.

> >     Speaking of which, I never did see where
> > you posted the results of
> > any drive access metrics.
> 
> I'm sure I mentioned these are the WD 2TB drives.  Straight read 77.7MB/s
>  in RAID10offset.
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
