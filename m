From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 10:03:44 -0500
Message-ID: <4DCE99D0.1010900@hardwarefreak.com>
References: <20110513202900.GA1926@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110513202900.GA1926@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/13/2011 3:29 PM, Louis-David Mitterrand wrote:

> I've been having very bad performance with an LSISAS2008 controller
> attached to 8 WD Caviar Black 1TB disks.

What is the nature of this 'very bad performance'?  Did you recently
upgrade kernel/driver and run into a regression?  If not, either the HBA
has developed a circuit defect, or the problem lies elsewhere, either a
backplane/cabling issue, or a drive going south.

Do you have any log entries showing problems with the LSI HBA?  Drive
errors?  What does smartctl tell you about each drive?

Usually when HBAs fail, they fail, period.  They don't typically show
continuously degrading performance until totally failing.

I'll be interested to know if swapping the LSI for the Adaptec fixes the
'very bad performance' issue.

-- 
Stan
