From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 13:19:44 -0500
Message-ID: <4DCEC7C0.80306@hardwarefreak.com>
References: <20110513202900.GA1926@apartia.fr> <4DCE99D0.1010900@hardwarefreak.com> <20110514151812.GA3074@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514151812.GA3074@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/14/2011 10:18 AM, Louis-David Mitterrand wrote:
> On Sat, May 14, 2011 at 10:03:44AM -0500, Stan Hoeppner wrote:
>> On 5/13/2011 3:29 PM, Louis-David Mitterrand wrote:
>>
>>> I've been having very bad performance with an LSISAS2008 controller
>>> attached to 8 WD Caviar Black 1TB disks.
>>
>> What is the nature of this 'very bad performance'?  Did you recently
>> upgrade kernel/driver and run into a regression?  If not, either the HBA
>> has developed a circuit defect, or the problem lies elsewhere, either a
>> backplane/cabling issue, or a drive going south.
> 
> The performance problem can be clearly attributed to that model of the
> LSI card because with the Adaptec card and the same cables and disks the
> problem disappears.

How have you ascertained this already?  As of 2 hours ago you still
don't have your filesystem(s) back up and running after the HBA swap.  I
would assume a backup restore of a few TB would take more than a few
hours...

> The LSI card has always performed very poorly with all kernel versions I
> tried, including the very latest, and the with most recent firmware
> revisions from LSI.

LSI HBAs are usually held in pretty high regard.  Which specific part#
are we talking about?  Is this an OEM Dell HBA?

> After bricking the card while trying to change its firmware to an "IT"
> version (Initiatior Target i.e. non-raid) I had Dell send me a new one
> on warranty and the performance problem remained.

You still haven't described the nature of the performance problem.  This
is a technical mailing list after all.

>> Do you have any log entries showing problems with the LSI HBA?  Drive
>> errors?  What does smartctl tell you about each drive?
> 
> No error. Just plain sloth.

Interesting technical description.  Now we have yet another post in the
Interwebs archives stating a certain piece of hardware is junk without
any real explanation as to the nature of the problem...

-- 
Stan
