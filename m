From: "John Stoffel" <john@stoffel.org>
Subject: Re: Odd --examine output
Date: Thu, 18 Apr 2013 09:03:31 -0400
Message-ID: <20847.61219.343100.819285@quad.stoffel.home>
References: <20130416085857.GB25795@cthulhu.home.robinhill.me.uk>
	<19242720.12.1366284822099.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19242720.12.1366284822099.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Robin Hill <robin@robinhill.me.uk>, Linux RAID <linux-raid@vger.kernel.org>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids


>> > Roy> I still don't understand why people use partitions for RAID
>> > when
>> > Roy> the whole drive is used anyway. Partitions were invented to
>> > Roy> partition things up and are of no use if you want to spend the
>> > Roy> whole drive's space for RAID use (or otherwise).
>> >
>> > Because if I take a 2tb disk a I put a partition on there which is a
>> > bit smaller than the full disk, if I then add a new 2tb (or any
>> > other
>> > size) disk which says it's 2tb, but it's really a bit smaller, then
>> > I'm not screwed. I've had it happen.
>> >
>> Recently? AFAIK, all modern drives (everything over 320G-ish IIRC) use
>> standardised sizes (i.e. any 2TB disk will present exactly the same
>> number of sectors). I recall reading that all the manufacturers agreed
>> to do this to prevent just this sort of issue, though I can't find a
>> reference to it now.

Roy> Indeed - you have to go back to smaller drives than those in
Roy> current production to find varying sizes for equally labelled
Roy> drive sizes.

Who says it might never happen again, that drive makers go back to
varying block counts for disks?  Or SSDs?  Better safe than sorry, and
a gig of wasted space is cheap insurance.  Plus, it gives you a place
to put boot blocks for GRUB, etc.  

John
