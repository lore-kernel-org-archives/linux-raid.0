From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: migrating from RAID5 to RAID10
Date: Wed, 9 Jun 2010 08:11:33 -0700
Message-ID: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

I have been using RAID5 on a desktop machine using a couple of 500 GB
drives.  My original intent was to grow the array by adding more drives,
as the need arises.  I am now looking to expand the capacity (by adding
one more drive, for simplicity assume it's an identical one) but I'd
also like to switch to RAID10, which (I understand) has much better read
and write performance compared to RAID5 with more than two drives.  It
is my understanding that growing a RAID10 array is not yet supported,
but my hope is that by the time I need to expand again it will already
be supported ;-)  Finally, I'd like to do the migration on a "live"
machine, to the extent possible (I will use a remote backup, at least
for some of the data).

I'd like to hear your thoughts about whether or not the following is
a good way to perform the migration:

1. Backup data.

2. Remove one of the drives from the current array, causing it to work
   in degraded mode.

3. Start a new RAID10 array with two actual drives (the one removed from
   the existing array and the new one) and one "missing" drive.  I know
   that other RAID levels (e.g. 1 and 5) can be created with a missing
   drive, not sure about RAID10 though.  If this actually works, I'll
   get a 750 GB array working in degraded mode.

4. Copy the data from the old array to the new array.

5. Kill the old array entirely; add the remaining drive to the new array
   and watch it rebuild.

My main doubts are about step 3 above, and of course the fact that
a drive failure at any point between 2-5 (except when 4 has fully
completed and before going to 5) means losing data and having to resort
to backup.

A separate question concerns which layout I should be using for RAID10,
it sounds like f2 is the way to go, isn't it?

Your advice is much appreciated. Thanks!

Gilad
