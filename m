From: Bryan Mark Mesich <bmesich@atlantis.cc.ndsu.nodak.edu>
Subject: Re: Useful benchmarking tools for RAID
Date: Thu, 13 Mar 2008 17:58:35 -0500
Message-ID: <1205449115.30451.214.camel@atlantis.cc.ndsu.nodak.edu>
References: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>
	 <18393.37268.150207.688089@tree.ty.sabi.co.uk>
Reply-To: bryan.mesich@ndsu.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18393.37268.150207.688089@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thu, 2008-03-13 at 20:41 +0000, Peter Grandi wrote:
> bmesich> [ ... ] performance of our IMAP mail servers that have
> bmesich> storage on-top RAID 5. [ ... ]
> 
> That may be not a good combination. I generally dislike RAID5,
> but even without being prejudiced :-), RAID5 is suited to a
> mostly-read load, and a mail store is usually not mostly-read,
> because it does lots of appends. In particular it does lots of
> widely scattered appends. As usual, I'd rather use RAID10 here.
> 
> Most importantly, the structure of the mail store mailboxes
> matters a great deal e.g. whether it is mbox-style, or else
> maildir-style, or something else entirely like DBMS-style.

We are currently using mbx mail format, but are looking into switching
to mixed (not sure if 'mixed' is the correct terminology).  We were
hoping that the smaller file sizes would in turn cause more efficient
I/O. Any thoughts on this change?
> 
> bmesich> During peek times of the day, a single IMAP box might
> bmesich> have 500+ imapd processes running simultaneously.
> 
> The 'imapd's are not such a big deal, the delivery daemons may be
> causing more trouble, and the interference between the two, and
> the type of elevator. As to elevator in your case who knows which
> would be best, a case could be made for 'anticipatory', another
> one for 'deadline', and perhaps 'noop' is the safest. As usual,
> flusher parameters are also probably quite important. Setting the
> RHEL 'vm/max_queue_size' to a low value, something like 50-100 in
> your case, might be useful.
> 
Good point on both.  The imap boxes are currently using cfq (Red Hat
default).  I've been setting up SAR to collect data points so when we
decide to change the scheduler, we have have something to measure
against.

> Now that it occurs to me, another factor is whether your users
> access the mail store mostly as a download area (that is mostly
> as they would if using POP3) or they actually keep their mail
> permanently on it, and edit the mailboxes via IMAP4.

In our setup, the mail servers store the mail permanently (unless users
delete).  Users have a 512MB quota on their mailboxes. 

[Cut]
> bmesich> 1 GB of memory
> 
> Probably ridiculously small. Sad to say...

Your right, 1GB on a mail server is small in this case.  In my attempt
to simplify my problems I left out some of the complexities of our
storage layout.  I reality, the imap servers store their mail on
mirrored SAN volumes via Dual 4GB fibre channel HBA's.  Typical volume
size for the mail to sit on is around 250GB.  The fibre targets are
running RAID5 in a 3+1 layout in separate geographic areas (my test box
is a fibre target replacement not yet in service, thus the small amount
of memory).  I should also mention that we are using bitmaps on the
RAID1 array.  Possibly moving these to local disk would increase
performance some?

We're using 3rd party software developed by Pavitrasoft to export the
volumes to the initiators.  We been looking a SC/ST as a replacement for
Pavitrasoft's software, but are unsure about moving to it.  I've done
little reading on RAID10, but what I have read looks promising in regard
to write performance improvements.  I'll setup a RAID 10 array with 8
drives and run some benchmarks.  

[Cut]
> bmesich> I've setup 3 RAID5 arrays arranged in a 3+1 layout.  I
> bmesich> created them with different chunk sizes (64k, 128k, and
> bmesich> 256k) for testing purposes.
> 
> Chunk size in your situation is the least of your worries. Anyhow
> it depends on the structure of your mail store.

Some of my readings indicated that larger chunk sizes can increase I/O
performance where random writes/reads occur often.  Any thoughts on
this? 
> 
> bmesich> Write-caching has been disabled (no battery) on the
> bmesich> 3Ware cards
> 
> That can be a very bad idea, if that also disables the builtin
> cache of the disks. If the ondisk cache is enabled it probably
> matters relatively little. Anyhow for a system like yours doing
> what it does I would consider battery backup *for the whole
> server* pretty important.

Good point.  I was unaware that disabling write-chaching on the
controller might effect the cache on the drives themselves.  As for
battery backup, the whole data center is protected by a UPS.  I was
referring to controller batteries on the 3ware cards.  I was under the
assumption that batteries on the controllers are a must when using
write-caching sensibly.  Any ideas on how much write-caching is needed
to be useful?  I calculated the average I/O request size to be around
440k/sec.  So, with a 128MB of cache ([128*1024]/440)/60 = 4.9 minutes
of cache time before it is over-writen?  
> 
> bmesich> and I'm using ext3 as my filesystem.
> 
> That's likely to be a very bad idea. Consider just this: your
> 3+1 arrays have one 3x750GB filesystem each (I guess). How long
> could 'fsck' of one of those take? You really don't want to know.

We have a 850GB volume running ext3 on an ftp server.  It takes a very
long time :(
> 
> Depending on mail store structure I'd be using ReiserFS, or JFS
> or even XFS. My usual suggestion is to use JFS by default unless
> one has special reasons.

Is JFS being supported my IBM anymore?  Other options I'm looking at
would be to move the (SAN) filesystem journal to local disk. 

[Cut]
> Note however that the seek rates are not much higher than yours,
> more or less of course.

Looks good.  I'll have to try it out.

[Cut]
> 
> bmesich> With this said, has anyone ever tried tuning a RAID5
> bmesich> array to a busy mail server (or similar application)?
> 
> Note a little but important point of terminology: a mail server
> and a mail store server are two very different things. They may
> be running on the same hardware, but that's all.

Thanks for the correction :)

[Cut]
> I would dearly hope that you have several good (with a fair bit
> of offloading) 1gb/s interfaces with load balancing across them
> (either bonding ro ECMP), or at least one 10gb/s interface, and a
> pretty good switch/router/network, and your have set the obvious
> TCP parameters for high speed network transfer over high bandwidth
> links.

We are currently running 7 imap servers servicing around 15,000+ users.
You're absolutely right, I think we would benefit from have more
hardware to spread the users across.  Users are relatively balanced
between the imap servers, but there are just too many users. I'm hoping
we get an additional 2 imap servers to help out the load. 
> 
> If your users are typical contemporary ones and send each other
> attachements dozens of megabytes long, a single 1gb/s interface
> that can do 110MB/s with the best parameter is not going to be
> enough.

The most damaging user actions seem to be internal listserv messages
marked for thousands of users.  Holding these messages until night time
(when the load is down), or educating our user base may help some.
--
Thanks for the reply,

~Bryan
