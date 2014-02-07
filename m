From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Storage system
Date: Fri, 7 Feb 2014 08:29:19 -0600
Message-ID: <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
References: <20140206180909.GA2419@lazy.lzy>
	<52F49433.8080904@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F49433.8080904@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

FWIW, I use a program called "shred" when I'm done with a disk.  It
makes N (default = 3) passes of writing random data to the disk, and
an optional final pass of zeroes.  It's time-consuming to complete,
but takes only 30 seconds to get going.  Even more convenient if you
have one of those USB hard drive docks, so you can take the drive out
of your system.

Based on what I've read, that should be sufficient to keep anyone
without a Dept of Defense budget from recovering you data.  The DOD
probably already has your data anyway, so that's a non-issue.  :)



On Fri, Feb 7, 2014 at 2:07 AM, David Brown <david.brown@hesbynett.no> wrote:
> On 06/02/14 19:09, Piergiorgio Sartor wrote:
>> Hi all,
>>
>> this question is only partially related to Linux MD,
>> but since the experts are here, I think it would not
>> be a big problem to ask here.
>>
>> I'm considering a storage system.
>> This is based on HDD "rust".
>> It should have RAID-6, for protection agaist disk
>> failure(s).
>> It should have LUKS (or similar), in order to simplify
>> HDD disposal (disk that are still somehow readable will
>> not need to be wiped out before dumping them).
>> It should have LVM, as flexible partition system.
>>
>
>
> It strikes me as a bad idea to use encryption of any sort "to save time
> when dumping old disks".  Physically destroying hard disks is not /that/
> hard.  Unless you are keeping plans for a nuclear missile, then a few
> whacks with a hammer will be good enough.  Breaking the electronics
> means it costs many thousands of dollars to get the data off the disk
> again - you don't even need to open the drive and get out the platters
> (opening the drive is time-consuming - destroying the platters after
> opening is easy).  And with raid, little of the data on the disk is
> intelligible unless you have the full stripe (minus parity) - just ask
> anyone who has tried to recover from one too many disk failures.
>
> And of course, just dd'ing /dev/zero to the first few MB of the disk
> will make it unreadable for most hackers - even if they have all the
> disks in a set, and know how they were configured.  And you could donate
> the old disks to windows users - then they are guaranteed unreadable!
>
> Disk encryption slows everything down, and adds lots of complications to
> the system.  It is less of an issue with drives with built-in
> encryption, but still a complete waste of time and money if all you want
> is "safe" disposal of old disks.
>
> The /only/ thing disk encryption is useful for is if you fear the disks
> will be physically stolen by someone who is after your data (or customs
> guards in dodgy countries, which amounts to the same thing).  So if you
> fear that your company will be the target of top-range thieves who will
> steal your disks for the data, then encryption is a good idea.  Of
> course, better locks and alarm systems would be a better investment.
>
>
> Once you have eliminated the "E", then I believe HRL is the common
> arrangement, although sometimes you also do physical partitioning of the
> disks first, so that you can have different bits with different raid
> types.  A multi-way raid1 partition first for /boot can make booting
> easier, a set of raid1 pairs works well for swap (for emergency use
> only), and then the rest of each disk makes up your raid6 array.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
