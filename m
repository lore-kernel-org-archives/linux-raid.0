From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID5 -> RAID6
Date: Sun, 29 Mar 2009 07:41:29 +1100 (EST)
Message-ID: <a741976bf24fa274ac54be1f31d8bc2e.squirrel@neil.brown.name>
References: <49CE20B3.9010101@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CE20B3.9010101@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, March 29, 2009 12:05 am, Max Waterman wrote:
> Hi,
>
> I'm wondering what the latest is on migrating from RAID5 to RAID6.
>
> I have a 6 disk RAID5 with 2 spares and have long been thinking of
> making better use of the spares. All 200GB.
>
> I have a 1TB drive that is serving as a backup, but I wonder if there's
> a way to migrate without having to wipe the array.
>
> Any advice?

Wait 3 months :-)

2.6.30 should contains support for this sort of conversion.  It is
already written (mostly) but still needs some testing.


Your options would then include:
 1/  convert that raid5 to a raid6 of the same size but with one
     extra device.  This device would store all the 'Q' blocks so
     it could become a write bottle neck
 1a/ as above, but then restripe the array so that the Q block is
     rotated among the drives.  This process is either dangerous - in
     that a crash would kill your data, or slow - in that all the data
     would need to be copied elsewhere in chunks while the corresponding
     chunk of the array was restriped.
 2/  convert to raid6 and grow at the same time.  i.e. add both spares
     using one of them to support the conversion to raid6 and the
     other to increase the space.  You could then arrange to restripe
     an grow at the same time which is faster/safer than striping in-place.
 3/  Possibly you could restripe-and-grow, then restripe-and-shrink
     so you end up with a 7 device RAID6 with properly rotating parity,
     but don't go through the slow/dangerous restripe-in-place.
     I'll need to do some experiments to see if that would actually
     be faster.

NeilBrown

