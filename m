From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: RE: Awful RAID5 random read performance
Date: Sun, 31 May 2009 22:19:48 -0300
Message-ID: <18979.11444.742791.975816@fisica.ufpr.br>
References: <4A227832.1090808@anonymous.org.uk>
	<20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer (lrhorer@satx.rr.com) wrote on 31 May 2009 10:41:
 >> > I happen to be the friend Maurice was talking about. I let the raid
 >> layer keep
 >> > its default chunk size of 64K. The smaller size (below like 2MB) tests
 >> in
 >> > iozone are very very slow. I recently tried disabling readahead,
 >> Acoustic
 >> > Management, and played with the io scheduler and all any of it has done
 >> is
 >> > make the sequential access slower and has barely touched the smaller
 >> sized
 >> > random access test results. Even with the 64K iozone test random
 >> read/write is
 >> > only in the 7 and 11MB/s range.
 >> >
 >> > It just seems too low to me.
 >> 
 >> I don't think so; can you try a similar test on single drives not using
 >> md RAID-5?
 >> 
 >> The killer is seeks, which is what random I/O uses lots of; with a 10ms
 >> seek time you're only going to get ~100 seeks/second and if you're only
 >> reading 512 bytes after each seek you're only going to get ~500
 >> kbytes/second. Bigger block sizes will show higher throughput, but
 >> you'll still only get ~100 seeks/second.
 >> 
 >> Clearly when you're doing this over 4 drives you can have ~400
 >> seeks/second but that's still limiting you to ~400 reads/second for
 >> smallish block sizes.
 >
 >	John is perfectly correct, although of course a 10ms seek is a
 >fairly slow one.

Unfortunately it doesn't seem to be. Take a well-considered drive such
as the WD RE3; it's spec for average latency is 4.2ms. However does it
include the rotational latency (the time the head takes to reach the
sector once it's on the track)? I bet it doesn't. Taking it to be only
the average seek time, this drive is still among the fastest. For a
7200rpm drive this latency is just 4.2ms, so we'd have for this fast
drive an average total latency of 8.4ms.

 >	The biggest question in my mind, however, is why is random access a
 >big issue for you?  Are you running a very large relational database with
 >tens of thousands of tiny files?  For most systems, high volume accesses
 >consist mostly of large sequential I/O.

No, random I/O is the most common case for busy servers, when there
are lots of processes doing uncorrelated reads and writes. Even if a
single application does sequential access the head will likely have
moved between them. The only solution is to have lots of ram for
cache, and/or lots of disks. It'd be better if they were connected to
several controllers...
