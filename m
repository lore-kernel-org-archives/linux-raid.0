From: "John Stoffel" <john@stoffel.org>
Subject: Re: Odd --examine output
Date: Mon, 15 Apr 2013 16:13:35 -0400
Message-ID: <20844.24431.814932.275104@quad.stoffel.home>
References: <CD917B51.41713%michael.vanhorn@wright.edu>
	<10112252.14.1366051374769.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10112252.14.1366051374769.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Mike Vanhorn <michael.vanhorn@wright.edu>, Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Roy" == Roy Sigurd Karlsbakk <roy@karlsbakk.net> writes:

>> >NOT a guess. Back up what you can, while you can, and start over. Use
>> >"fdisk -u" so you can ensure partitions start on multiples of eight
>> >(8)
>> >sectors. (Modern fdisk uses 1MB alignment by default. Highly
>> >recommended.)
>> >
>> >
>> 
>> So, if I start the partition at sector 64 (rather than 63), that's
>> better,
>> right (since 64 is a multiple of 8)? Or is there more math to do and
>> I'm still not getting it?

Roy> I still don't understand why people use partitions for RAID when
Roy> the whole drive is used anyway. Partitions were invented to
Roy> partition things up and are of no use if you want to spend the
Roy> whole drive's space for RAID use (or otherwise).

Because if I take a 2tb disk a I put a partition on there which is a
bit smaller than the full disk, if I then add a new 2tb (or any other
size) disk which says it's 2tb, but it's really a bit smaller, then
I'm not screwed.  I've had it happen.

John
