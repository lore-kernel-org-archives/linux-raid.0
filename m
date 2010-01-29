From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid10 How do I tell what side of the mirror a disk is on?
Date: Sat, 30 Jan 2010 00:50:02 +0100
Message-ID: <87k4v0wjx1.fsf@frosties.localdomain>
References: <1264777247.29409.64.camel@thor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264777247.29409.64.camel@thor> (Rick Bragg's message of "Fri,
	29 Jan 2010 10:00:47 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rick Bragg <lists@gmnet.net> writes:

> Hi,
>
> I recently posted a question to find out how to tell what is sda, b, c,
> etc... and I am now using smartctl to get the serial numbers and all is
> really great.  Thanks everyone for that info!
>
> Another puzzle is with raid10, there are 2 used in a stripe, then that
> stripe is mirrored with the other 2.  My question is how can I tell
> "what 2 disks can fail?"  In other words, how can I tell for example if
> sda and b are stiped? and that c and d are a mirror of a and b?  How can
> I see what is happening with that?  Is there a way to tell?  
>
> Thanks
> Rick

Does it matter? If one disk fails you know the next disk failure has a
33+% chance of data loss and knowing which disk will be critical doesn't
change that.

MfG
        Goswin

PS: why not set up a raid over /dev/ramX with the same option of your
real raid, fail some disks and see when it breaks down.
