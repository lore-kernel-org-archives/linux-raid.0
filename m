From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Adaptec 3210S Problems
Date: Sat, 2 Apr 2005 20:39:44 -0500
Message-ID: <200504030139.j331dnm26359@www.watkins-home.com>
References: <Pine.LNX.4.62.0504021851590.9514@gandalf>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0504021851590.9514@gandalf>
Sender: linux-raid-owner@vger.kernel.org
To: "'Brett I. Holcomb'" <brettholcomb@charter.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Brett I. Holcomb
> Sent: Saturday, April 02, 2005 6:54 PM
> To: linux-raid@vger.kernel.org
> Subject: RE: Adaptec 3210S Problems
> 
> Followup for the archives.  With the help of several it turns out to be
> termination (surprise!!! <G>).  I've used non-RAID SCSI for years and have
> always been paranoid about terminating.  However, this system was set up
> for me by someone that I assumed (yes, I know <G>) knew RAID better than I
> did.  The drives are in caddies that are hot swappable and the drive ID is
> assigned by the caddy frame.  Consequently the installer did not put any
> jumpers on the  drives and did not terminate the last drive.
> 
> Thanks all.

In a cabinet as you describe, it is normal to put a terminator on the
cabinet, not the drive.  Maybe that is what you did, but you made it sound
like you installed a jumper on the last drive.  In a cabinet as you describe
you would not put jumpers directly on the drives.  If you did so, then it
makes it harder when replacing a drive.  All drives should be just plug and
go.

> 
> 
> 
> On Mon, 21 Mar 2005, Salyzyn, Mark wrote:
> 
> > Termination, Cabling and/or Drive Firmware Incompatibilities. Good idea
> > to get your TSID ready, list of components and their firmware versions
> > and call Adaptec Support and work through the discovery cookbook.
> >
> > Sincerely -- Mark Salyzyn
> >
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brett I. Holcomb
> > Sent: Saturday, March 19, 2005 1:22 AM
> > To: linux-raid@vger.kernel.org
> > Subject: Adaptec 3210S Problems
> >
> > I'm running a Linux system with a Adaptec 3210S controller.  Right now
> > the
> > system has nothing on it and I have not created any RAID.  I've notice
> > that when I boot into the Adaptec CD and watch the drives they keep
> > getting flagged as missing.  If I do a "Read system config" the drives
> > show up and the flag goes away.  A few minutes later they are flagged as
> >
> > missing again.  This is a little discouraging as it appears I have a
> > problem.  Any ideas on what is happening - why do my drives keep getting
> >
> > flagged as missing?  I need to find out before I install Linux!
> >
> > Thanks.
> >
> >

Guy

