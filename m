From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 14:48:38 +0300
Message-ID: <45AB6A16.8010001@tls.msk.ru>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>  <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>  <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu> <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com> <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <Pine.LNX.4.64.0701131903270.16472@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701131903270.16472@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Robin Bowes <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
[]
> if this is for a database or fs requiring lots of small writes then 
> raid5/6 are generally a mistake... raid10 is the only way to get 
> performance.  (hw raid5/6 with nvram support can help a bit in this area, 
> but you just can't beat raid10 if you need lots of writes/s.)

A small nitpick.

At least some databases never do "small"-sized I/O, at least not against
the datafiles.  That is, for example, Oracle uses a fixed-size I/O block
size, specified at database (or tablespace) creation time, -- by default
it's 4Kb or 8Kb, but may be 16Kb or 32Kb as well.  Now, if you'll make your
raid array stripe size to match the blocksize of a database, *and* ensure
the files are aligned on disk properly, it will just work without needless
reads to calculate parity blocks during writes.

But the problem with that is it's near impossible to do.

First, even if the db writes in 32Kb blocks, it means the stripe size should
be 32Kb, which is only suitable for raid5 with 3 disks, having chunk size of
16Kb, or with 5 disks, chunk size 8Kb (this last variant is quite bad, because
chunk size of 8Kb is too small).  In other words, only very limited set of
configurations will be more-or-less good.

And second, most filesystems used for databases don't care about "correct"
file placement.  For example, ext[23]fs with maximum blocksize of 4Kb will
align files by 4Kb, not by stripe size - which means that a whole 32Kb block
will be laid like - first 4Kb on first stripe, rest 24Kb on the next stripe,
which means that for both parts full read-write cycle will be needed again
to update parity blocks - the thing we tried to avoid by choosing the sizes
in a previous step.  Only xfs so far (from the list of filesystems I've
checked) pays attention to stripe size and tries to ensure files are aligned
to stripe size.  (Yes I know mke2fs's stride=xxx parameter, but it only
affects metadata, not data).

That's why all the above is a "small nitpick" - i.e., in theory, it IS possible
to use raid5 for database workload in certain cases, but due to all the gory
details, it's nearly impossible to do right.

/mjt
