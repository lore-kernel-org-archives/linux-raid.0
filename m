From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Strategy Question
Date: Sat, 6 Aug 2005 09:19:25 -0500
Message-ID: <6d5bedd80508060719774828f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Finally got a RAID aware kernel built for version 0.7.1 of coLinux.
Important because that version has a combination of Samba and their
TAP driver that approaches the same amount of time it takes to
copy/read a file native from disk.

I have six external drives (some firewire, some usb-2). Two of the
drives are 200 Gigs, and the other 4 are 250 gigs. My internal drive
has 130 gigs free.

I'm pretty certain I want my first array to be 50 gigs from each of
the 4 250 gig drives. That will give me a first RAID-5 array of 150
gigs. I can then copy data to that array, and can also move some data
to my internal drive. The problem then is that I'd really like to use
one partition of 200 gigs on all six drives to build the other array,
but I don't have room for all my data.

So, am trying to figure out if my best option in that case is to build
the RAID-5 array, and somehow specify that there will be another drive
eventually, then copy the data to that drive while building, and then
move the data to the array and finally add that drive to the array

- or, setup two 100 gig partitions on each drive, and then build an
array for each set of partitions. So that once the first of these
arrays is setup, I can copy the data to that, and then do the final
array.

Thoughts, suggestions, recommended incantations?

TIA,
Ewan
