From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Raid 6--best practices
Date: Wed, 25 Jan 2012 12:28:00 +0000
Message-ID: <20255.62800.372861.309853@tree.ty.sabi.co.UK>
References: <4F173D3D.6070902@npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
	<jfbfk6$gqk$1@dough.gmane.org>
	<4F199C09.80202@npr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F199C09.80202@npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> I have been doing some research into possible alternatives to
>> our OpenSolaris/ZFS/Gluster file server. The main reason
>> behind this is, due to RedHat's recent purchase of Gluster,
>> our current configuration will no longer be supported and
>> even before the acquisition, the upgrade path for the
>> OpenSolaris/ZFS stack was murky at best.

You could be using FreeBSD/ZFS, or just keep using Gluster
indeed as you seem going to do, which is quite good overall, and
the sale to RH just means it will have *much* better chance of
being maintained for the foreseeable future, but not OpenSolaris.

>> The current servers in question consist of a total of 48, 2TB
>> drives. My thought was that I would setup a total of 6 RAID-6
>> arrays (each containing 7 drives + a spare or a flat 8 drive
>> RAID-6 config) and place LVM + XFS on top of that.

That's the usual (euphemism alert) imaginative setup that
follows what I call a "syntactic" logic (it is syntactically
valid!).

Note: You could have 1-2 spares and share them among all sets.

Also, the 2TB drives are likely to be consumer-grade ones with
ERC disabled, unless you chose carefully or got lucky.

>> My questions really are: a) What is the maximum number of
>> drives typically seen in a RAID-6 setup like this?

Any number up to 48. Really, because "typically seen" is a naive
question, because what is "typically seen" could be pretty bad.

>> I noticed when looking at the Backblaze blog, that they are
>> using RAID-6 with 15 disks (13 + 2 for parity).

Backblaze have a very special application. A wide RAID6 _might_
make sense for them.

>> That number seemed kind of high to me....

That's good you seem to be a bit less (euphemism alert)
audacious than most sysadms, who just love very wide RAID6,
because of an assumption that I find (euphemism alert)
fascinating:

     http://WWW.sabi.co.UK/blog/1103Mar.html#110331

What matters to me is the percentage of redundancy adjusted by
disk set geometry and implications for rebuild.

In general, unless someone really knows better, RAID10 or RAID1
should be the only choices. Of course everybody knows better :-).

>> but I was wondering what others on the list thought.

I personally think that the best practice with both RAID6 and
LVM2 is never to use them (with minuscule exceptions), and in
particular never to use 'concat'.

>> b) Would you recommend using any specific Linux distro over
>> any other?  Right now I am trying to decide between Debian and
>> Ubuntu....but I would be open to any others...if there was a
>> legitimate reason to do so (performance, stability, etc) in
>> terms of the Raid codebase.

Does not matter that much, but you might want a distro that
comes with some kind of "enterprise support", like RHEL or SLES
or derivatives, or Ubuntu LTS. Of course these at most points in
time are relatively old.

> At this point we are storing mostly larger files such as audio
> (.wav, .mp3, etc) and video files in various formats.  The
> initial purpose of this particular file server was meant to be
> a long term media storage 'archive'. The current setup was
> constructed to minimize data loss and maximize uptime, and
> other considerations such as speed were secondary.  [ ... ]
> The initial specification called for relatively low reads and
> writes, since we are basically placing the files there
> once(via CIFS or NFS), and they are rarely if ever going to
> get updated or re-written.

> Uptime is relatively important, although given that we are
> using Gluster, we should have access to our data if we have a
> node failure, the issue then becomes having to sync up the
> data which is always a little pain...but should not involve
> any downtime.

Fortunately you are storing relatively large files, so a
filetree is not a totally inappropriate container for that.
Still I would use a database for "blobs" of that size, for many
reasons.

Since your application is essentially append/read only, you can
just fill one filetree, remount it RO, and start filling another
one, and so on, so you don't really need to have a shared free
space pool, or you could use Gluster over each single
independent filetree.

If you have a layer of redundancy anyhow (e.g. DRBD or Gluster
replicated volumes) as you seem to have I would use a number of
narrow RAID5 sets, something like 2+1 or 4+1 (at most), as the
independent filetrees. Because your application is like that it
seems one of the few suited to RAID5:

  http://www.sabi.co.uk/blog/1104Apr.html#110401

As a completely different alternative, if you really really need
a single free space pool, you could consider a complete change
to Lustre over DRBD, but I think that Gluster over XFS over
RAID10 or RAID5 would be good.

> In terms of array rebuilding times, I think I would like to
> minimize them to the extent possible, but I understand they
> will be a reality given this setup.

Also consider 'fsck' time and space. A nice set of 2+1 RAID5
could be reasonable here.

> We have two 3ware 9650SE-24M8 in each node, but I was planning
> on trying to just export the disks as JBODs, and try not to
> use the cards for anything other then exporting the disks to
> the OS.

3ware firmware has been known to have horrifying firmware
issues:

  http://makarevitch.org/rant/3ware/
  http://www.mattheaton.com/?p=160

Note that the really noticeable bugs are behavioural ones, as in
poor request scheduling under load, and they happen even in
single drive mode. This is sad, because up to series 7000 I had
a good impression of 3ware HAs. But many nights spent trying to
compensate for the many issues of series 9000 have changed my
opinion.

Most other RAID HAs are also buggy, consider for example:

  http://www.gridpp.rl.ac.uk/blog/2011/01/12/sata-raid-controller-experiences-at-the-tier1/

In general using MD is rather more reliable. My usual list of
things should be defaults unless one knows a lot better: MD,
RAID10, SCT ERC, JFS or XFS, GPT partitioning; of things to
avoid unless there are special cases: firmware based RAID HAs,
any parity RAID level or 'concat', drives without ERC, ext3 (and
ext4), LVM2 or MBR partitioning.
