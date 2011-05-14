From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 21:15:33 +0200
Message-ID: <20110514191532.GA15753@apartia.fr>
References: <20110513202900.GA1926@apartia.fr>
 <4DCE99D0.1010900@hardwarefreak.com>
 <20110514151812.GA3074@apartia.fr>
 <4DCEC7C0.80306@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DCEC7C0.80306@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 01:19:44PM -0500, Stan Hoeppner wrote:
> On 5/14/2011 10:18 AM, Louis-David Mitterrand wrote:
> > On Sat, May 14, 2011 at 10:03:44AM -0500, Stan Hoeppner wrote:
> >> On 5/13/2011 3:29 PM, Louis-David Mitterrand wrote:
> >>
> >>> I've been having very bad performance with an LSISAS2008 controller
> >>> attached to 8 WD Caviar Black 1TB disks.
> >>
> >> What is the nature of this 'very bad performance'?  Did you recently
> >> upgrade kernel/driver and run into a regression?  If not, either the HBA
> >> has developed a circuit defect, or the problem lies elsewhere, either a
> >> backplane/cabling issue, or a drive going south.
> > 
> > The performance problem can be clearly attributed to that model of the
> > LSI card because with the Adaptec card and the same cables and disks the
> > problem disappears.
> 
> How have you ascertained this already?  As of 2 hours ago you still
> don't have your filesystem(s) back up and running after the HBA swap.  I
> would assume a backup restore of a few TB would take more than a few
> hours...

My system partiton is fine, thank you very much. Only my data partition
is affected by the geometry inconsistency. And the performance
difference was quickly obvious: 22 seconds to untar kernel sources vs 20
minutes.

> > The LSI card has always performed very poorly with all kernel versions I
> > tried, including the very latest, and the with most recent firmware
> > revisions from LSI.
> 
> LSI HBAs are usually held in pretty high regard.  Which specific part#
> are we talking about?  Is this an OEM Dell HBA?

In high regard by whom I wonder. I've found them generally crappy. My
last one (MegaRAID SAS 1078) wouldn't let the disks appear to the OS
unless I created a raid0 vdisk for each of them. How lame is that? And
the LSISAS2008 shipped with a firmware so crappy that a simple lilo run
would bump 2 out of my 8 disk raid6. Dont even get me started on Dell
with their overpriced parts and bloated 600MB OMSA suite just to do a
simple firmware upgrade.

And all that for what? Just to provide some lameass raid features I
don't need or use. I loathe hardware raid, would never trust it with my
data. As far as I'm concerned all these useless "features" stand in the
way of performance and simplicity.

But it seems finding a simple SAS/Sata expander with no raid and that
just gives me my fucking disks whole is too much to ask. They are either
out of stock, EOL, wrong plugs or not available in my area.

> > After bricking the card while trying to change its firmware to an "IT"
> > version (Initiatior Target i.e. non-raid) I had Dell send me a new one
> > on warranty and the performance problem remained.
> 
> You still haven't described the nature of the performance problem.  This
> is a technical mailing list after all.

Try 2 orders of magnitude time difference when rm'ing a kernel tree. No
errors.

> >> Do you have any log entries showing problems with the LSI HBA?  Drive
> >> errors?  What does smartctl tell you about each drive?
> > 
> > No error. Just plain sloth.
> 
> Interesting technical description.  Now we have yet another post in the
> Interwebs archives stating a certain piece of hardware is junk without
> any real explanation as to the nature of the problem...

It's junk and bloated with useless features.
