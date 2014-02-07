From: David Brown <david.brown@hesbynett.no>
Subject: Re: Storage system
Date: Fri, 07 Feb 2014 09:07:15 +0100
Message-ID: <52F49433.8080904@hesbynett.no>
References: <20140206180909.GA2419@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140206180909.GA2419@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/02/14 19:09, Piergiorgio Sartor wrote:
> Hi all,
> 
> this question is only partially related to Linux MD,
> but since the experts are here, I think it would not
> be a big problem to ask here.
> 
> I'm considering a storage system.
> This is based on HDD "rust".
> It should have RAID-6, for protection agaist disk
> failure(s).
> It should have LUKS (or similar), in order to simplify
> HDD disposal (disk that are still somehow readable will
> not need to be wiped out before dumping them).
> It should have LVM, as flexible partition system.
> 


It strikes me as a bad idea to use encryption of any sort "to save time
when dumping old disks".  Physically destroying hard disks is not /that/
hard.  Unless you are keeping plans for a nuclear missile, then a few
whacks with a hammer will be good enough.  Breaking the electronics
means it costs many thousands of dollars to get the data off the disk
again - you don't even need to open the drive and get out the platters
(opening the drive is time-consuming - destroying the platters after
opening is easy).  And with raid, little of the data on the disk is
intelligible unless you have the full stripe (minus parity) - just ask
anyone who has tried to recover from one too many disk failures.

And of course, just dd'ing /dev/zero to the first few MB of the disk
will make it unreadable for most hackers - even if they have all the
disks in a set, and know how they were configured.  And you could donate
the old disks to windows users - then they are guaranteed unreadable!

Disk encryption slows everything down, and adds lots of complications to
the system.  It is less of an issue with drives with built-in
encryption, but still a complete waste of time and money if all you want
is "safe" disposal of old disks.

The /only/ thing disk encryption is useful for is if you fear the disks
will be physically stolen by someone who is after your data (or customs
guards in dodgy countries, which amounts to the same thing).  So if you
fear that your company will be the target of top-range thieves who will
steal your disks for the data, then encryption is a good idea.  Of
course, better locks and alarm systems would be a better investment.


Once you have eliminated the "E", then I believe HRL is the common
arrangement, although sometimes you also do physical partitioning of the
disks first, so that you can have different bits with different raid
types.  A multi-way raid1 partition first for /boot can make booting
easier, a set of raid1 pairs works well for swap (for emergency use
only), and then the rest of each disk makes up your raid6 array.


