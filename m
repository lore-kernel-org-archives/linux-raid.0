From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 17:18:13 +0200
Message-ID: <20110514151812.GA3074@apartia.fr>
References: <20110513202900.GA1926@apartia.fr>
 <4DCE99D0.1010900@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DCE99D0.1010900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 10:03:44AM -0500, Stan Hoeppner wrote:
> On 5/13/2011 3:29 PM, Louis-David Mitterrand wrote:
> 
> > I've been having very bad performance with an LSISAS2008 controller
> > attached to 8 WD Caviar Black 1TB disks.
> 
> What is the nature of this 'very bad performance'?  Did you recently
> upgrade kernel/driver and run into a regression?  If not, either the HBA
> has developed a circuit defect, or the problem lies elsewhere, either a
> backplane/cabling issue, or a drive going south.

The performance problem can be clearly attributed to that model of the
LSI card because with the Adaptec card and the same cables and disks the
problem disappears.

The LSI card has always performed very poorly with all kernel versions I
tried, including the very latest, and the with most recent firmware
revisions from LSI. 

After bricking the card while trying to change its firmware to an "IT"
version (Initiatior Target i.e. non-raid) I had Dell send me a new one
on warranty and the performance problem remained.

> Do you have any log entries showing problems with the LSI HBA?  Drive
> errors?  What does smartctl tell you about each drive?

No error. Just plain sloth.

