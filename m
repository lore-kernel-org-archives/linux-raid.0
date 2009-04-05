From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 16:02:08 -0500
Message-ID: <20090405210208.XEXH19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <49D903BA.8000000@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D903BA.8000000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Several, actually.  Since the RAID array kept crashing, I had to re-
> create
> > it numerous times.
> [...]
> >> your culprit is higher up the chain, ie the FS.
> >
> > I've suspected this may be the case from the outset.
> 
> I'm sorry? You've repeatedly had trouble with this system, this array,
> you've tried several filesystems; do you think they're *ALL* broken?

No, the other issues were clearly related to a single hardware issue.  It
took quite a while to find it, it being highly intermittent, but once I did,
replacing the culprit system apparently solved all the issues, and the
system ran fine for several weeks.  Then I reconfigured and formatted under
reiserfs.  That's when this issue popped up.  It's entirely possible there
is a persistent hardware problem which has plagued the system from day 1,
but was masked by the other, more severe hardware issue.  It's possible one
of the drives or some other component went bad just as I reformatted the
array.  It's possible moving the drives physically around has introduced
some problem.  It's possible whatever issue was causing the symptoms went
quiescent during the testing phase after the chassis was replaced.  All are
unlikely given the physical evidence, but none impossible.  To go any
further, I need further diagnostics.

Look, people, I am not a duffer.  I am a professional engineer who has been
in this business for over 30 years.  Personal computers and Linux are not my
area of expertise, but hardware systems and troubleshooting them are.  I am
not asking for anyone to fix my system for me, and I am perfectly capable of
drawing reasonable conclusions from empirical data.  Don't be surprised if
my conclusions differ from yours, but don't make the mistake of thinking I
have discarded any possible solutions, either.  Explain to me how the
alignment of Jupiter and Mars with Lake Michigan could be having an effect,
and I will look into it.  In the mean time, I need the advice of those more
experienced with Linux and possibly PCs than I.  That's you.

