From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Useful benchmarking tools for RAID
Date: Thu, 13 Mar 2008 20:41:56 +0000
Message-ID: <18393.37268.150207.688089@tree.ty.sabi.co.uk>
References: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 12 Mar 2008 17:27:58 -0500, Bryan Mark Mesich
>>> <bmesich@atlantis.cc.ndsu.nodak.edu> said:

bmesich> [ ... ] performance of our IMAP mail servers that have
bmesich> storage on-top RAID 5. [ ... ]

That may be not a good combination. I generally dislike RAID5,
but even without being prejudiced :-), RAID5 is suited to a
mostly-read load, and a mail store is usually not mostly-read,
because it does lots of appends. In particular it does lots of
widely scattered appends. As usual, I'd rather use RAID10 here.

Most importantly, the structure of the mail store mailboxes
matters a great deal e.g. whether it is mbox-style, or else
maildir-style, or something else entirely like DBMS-style.

bmesich> During peek times of the day, a single IMAP box might
bmesich> have 500+ imapd processes running simultaneously.

The 'imapd's are not such a big deal, the delivery daemons may be
causing more trouble, and the interference between the two, and
the type of elevator. As to elevator in your case who knows which
would be best, a case could be made for 'anticipatory', another
one for 'deadline', and perhaps 'noop' is the safest. As usual,
flusher parameters are also probably quite important. Setting the
RHEL 'vm/max_queue_size' to a low value, something like 50-100 in
your case, might be useful.

Now that it occurs to me, another factor is whether your users
access the mail store mostly as a download area (that is mostly
as they would if using POP3) or they actually keep their mail
permanently on it, and edit the mailboxes via IMAP4.

In the latter case the reliability of the mail store is even
more important, and the write rates even higher, so I would
recommend RAID10 even more strongly.

If you think that RAID10 costs too much in WASTED capacity,
good luck! :-)

Or you could investigate whether your IMAP server can do
compressed mailboxes. You got plenty of CPU power, more so
probably relative to your network speed.

bmesich> I'm currently testing with the following:
bmesich> Intel SE7520BD2 motherboard
bmesich> (2) 3Ware PCI-E 9550SX 8 port SATA card

Pretty good.

bmesich> 1 GB of memory

Probably ridiculously small. Sad to say...

bmesich> (2) Core2Duo 3.0GHz
bmesich> (16) Segate 750GB Barracuda ES drives
bmesich> RHEL 5.1 server (stock 2.6.18)

Pretty good. Those 16x750GB look like *perfect* for a nice sw
RAID10, with 8 pairs, with each member of a pair on a different
9550SX.

bmesich> I've setup 3 RAID5 arrays arranged in a 3+1 layout.  I
bmesich> created them with different chunk sizes (64k, 128k, and
bmesich> 256k) for testing purposes.

Chunk size in your situation is the least of your worries. Anyhow
it depends on the structure of your mail store.

bmesich> Write-caching has been disabled (no battery) on the
bmesich> 3Ware cards

That can be a very bad idea, if that also disables the builtin
cache of the disks. If the ondisk cache is enabled it probably
matters relatively little. Anyhow for a system like yours doing
what it does I would consider battery backup *for the whole
server* pretty important.

bmesich> and I'm using ext3 as my filesystem.

That's likely to be a very bad idea. Consider just this: your
3+1 arrays have one 3x750GB filesystem each (I guess). How long
could 'fsck' of one of those take? You really don't want to know.

Depending on mail store structure I'd be using ReiserFS, or JFS
or even XFS. My usual suggestion is to use JFS by default unless
one has special reasons.

There may well be special reasons! In your case ReiserFS would be
rather better if the mail store was organized as a lot of small
files, and XFS if it was organized as large mail archives files,
for example. XFS also has the advantages that it supports write
barriers (but not sure if the one in 2.6.18 already does), so you
could probably enable the host adapter cache, and that it handles
well very parallel access patterns. It has the disadvantage that
it can require several GB of memory to 'fsck' (like 1GB per 1TB
of filesystem, or more), and does not work as well with lots of
small files (while ReiserFS is very good, and JFS not too bad).

bmesich> When creating the filesystems, I used sensible stride
bmesich> sizes and disabled directory indexing.

That's very wise, both of that.

bmesich> I ran bonnie 1.4 on 2 of the filesystems with the following results:

               ---Sequential Output (nosync)--- ---Sequential Input-- --Rnd Seek-
               -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --04k (03)-

bmesich> Chunk size = 64k
bmesich> ./Bonnie -d /mnt/64/ -s 1024 -y -u -o_direct
bmesich> MB     K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
bmesich> 1*1024 59185 50.9 21849  7.5 14490  5.0 16377 24.1212812 25.3 267.8  1.5

bmesich> Chunk size = 256k
bmesich> ./Bonnie -d /mnt/256/ -s 1024 -y -u -o_direct
bmesich> MB     K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
bmesich> 1*1024 47650 40.6 22561  6.8 19019  6.9 16872 22.2209770 23.7 267.2  1.5

So you are getting 45-60MB/s writing and 210-220MB/s reading.
The reading rate is roughly reasonable (each of those disks can
do 70-80MB/s on the outer tracks), but the write speed is pretty
disastrous. Probably like many others you are using RAID5 without
realizing the pitfalls of parity RAID (amply explained in some
recent threads). Such pitfalls are particularly bad also if the
access patterns involve lots of small writes.

This is what I get on a 4x(1+1) RAID10 (with 'f2' for better read
performance, I would suggest the default 'n2' in your case) with
mixed 400GB and 1TB disks (and 'blockdev --setra 1024', regrettably
as detailed in a recent message of mine):

  # Bonnie -y -u -o_direct -s 2000 -v 2 -d /tmp/a
  Bonnie 1.4: File '/tmp/a/Bonnie.27318', size: 2097152000, volumes: 2
  Using O_DIRECT for block based I/O
  Writing with putc_unlocked()...done: 176107 kB/s  79.0 %CPU
  Rewriting...                   done:  31797 kB/s   3.1 %CPU
  Writing intelligently...       done: 243844 kB/s   9.6 %CPU
  Reading with getc_unlocked()...done:  22424 kB/s  28.3 %CPU
  Reading intelligently...       done: 475166 kB/s  14.9 %CPU
  Seek numbers calculated on first volume only
  Seeker 1...Seeker 2...Seeker 3...start 'em...done...done...done...
		---Sequential Output (sync)----- ---Sequential Input-- --Rnd Seek-
		-CharUnlk- -DIOBlock- -DRewrite- -CharUnlk- -DIOBlock- --04k (03)-
  Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU   /sec %CPU
  serv02 2*2000 176107 79.0243844  9.6 31797  3.1 22424 28.3475166 14.9  382.1  1.0

Note however that the seek rates are not much higher than yours,
more or less of course.

bmesich> OK...so now I have some benchmarks, but I'm not sure if
bmesich> it remotely relates to normal IO on a busy IMAP server.

I think that's unlikely -- Bonnie is a good test of the limits of
a _storage system_, not particularly of any given application
usage pattern (unless that application looks a lot like Bonnie).

bmesich> I would expect an IMAP server to have many relatively
bmesich> small random reads and writes.

Perhaps -- but it all depends on the structure of the mail store
and whether the users download mail or keep their mailboxes on
the server, and how big those mailboxes tend to be.

bmesich> With this said, has anyone ever tried tuning a RAID5
bmesich> array to a busy mail server (or similar application)?

Note a little but important point of terminology: a mail server
and a mail store server are two very different things. They may
be running on the same hardware, but that's all.

bmesich> An ever better question would be how a person can go
bmesich> about benchmarking different storage configurations
bmesich> that can be applied to a specific application. [ ... ] 
bmesich> Should I measure throughput or smiling email users :)

Your application is narrow enough. There are mail-specific
benchmarks, e.g. Postmark, but they tend to be for mail servers,
not mail store servers.

A mail store server is in effect though a file server, even if
the protocol is IMAP4 rather than SMB or NFS or WEBDAV. But file
size, number, and access patterns matter.

Thinking of file server, the hundreds of IMAP daemons and the
size of the mail store point to a large concurrent user base.

I would dearly hope that you have several good (with a fair bit
of offloading) 1gb/s interfaces with load balancing across them
(either bonding ro ECMP), or at least one 10gb/s interface, and a
pretty good switch/router/network, and your have set the obvious
TCP parameters for high speed network transfer over high bandwidth
links.

If your users are typical contemporary ones and send each other
attachements dozens of megabytes long, a single 1gb/s interface
that can do 110MB/s with the best parameter is not going to be
enough.
