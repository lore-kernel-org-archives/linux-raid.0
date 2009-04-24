From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Fri, 24 Apr 2009 16:25:29 -0400
Message-ID: <87f94c370904241325r25913030l4cb4828d7f2a5807@mail.gmail.com>
References: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
	 <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

<snip>
> 5. =A0Finally, one other thing concerns me a bit. =A0The researchers =
I read
> suggested XFS has by far the worst file deletion performance of any o=
f the
> journaling file systems, and Reiserfs supposedly has the best.

I'm pretty sure that someone got that wrong.  The real issue is that
xfs is really slow comparatively at deleting *small* files.

I did a test just a couple months ago comparing reiser and xfs.  xfs
was 30x slower.

My test was to make a copy of a linux kernel source tree.  Then time
deleting it.

Reiser did it in a couple seconds.  xfs took a minute.  So xfs is not
a good choice to hold your source directories it your a kernel
developer.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
