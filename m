From: "Bradley D. Thornton" <website.is@www.NorthTech.US>
Subject: Re:  =?ISO-8859-1?Q?=20=BF?= the best journalist-filesystem for a   raid5 ?
Date: Tue, 8 Jul 2003 14:34:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <befdg2$ev7$1@main.gmane.org>
References: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130> <Pine.LNX.4.44.0307031157450.18503-100000@chaos.egr.duke.edu>
Reply-To: "Bradley D. Thornton" <gmane@tallship.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


"Joshua Baker-LePain" <jlb17@duke.edu> wrote in message
news:Pine.LNX.4.44.0307031157450.18503-100000@chaos.egr.duke.edu...
> On Thu, 3 Jul 2003 at 5:42pm, system_lists@nullzone.org wrote
>
> >     i dont wanna create a discusion between gurus. My question is so
simple
> > (well .. its not simple but ...).
> >
> > What do u think is the best journalist filesystem for a software raid5
of
> > 4*120 GB IDE UATA ?
> > I will use this one for big files (lots of them) and small ones (just a
ftp
> > but too for the users space).
> >
> > For a non-specific BIG/SMALL files .... JFS? Reiser3? Reiser4? EXT3?
>
> I've had very good luck with XFS for a long time now (over 2 years in
> production, currently 5.5TB of formatted space).

I guess that leads me to the question, does ReiserFS NOT support ACLs? I
understand that XFS does (with a patch), but the page that I got this
information from is kind of old
(http://www.linux-mag.com/2002-10/jfs_01.html - which may also assist in
helping one decide which file system to go with I suppose).

The reason I ask is because I am interested in SAMBA/CIFS applications
running Linux as a file server/PDC

>
> -- 
> Joshua Baker-LePain
> Department of Biomedical Engineering
> Duke University
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.449 / Virus Database: 251 - Release Date: 01/27/03



