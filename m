From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Wed, 16 Aug 2006 08:03:50 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net>
References: <44E250CD.5040308@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E250CD.5040308@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Aug 2006, andy liebman wrote:

> -- If I were to create disk images of EACH drive (i.e., /dev/sda and
> /dev/sdb), could I restore each of those images to NEW drives -- with
> all of their respective partitions -- and have a working RAIDED OS?  I
> ask because my ultimate goal is to put a RAIDED OS on many systems, and
> once I get ONE working, it would be nice to clone them the way I already
> clone SINGLE OS drives. Can you clone RAIDS?

Yes.

I did this some time back to create half a dozen identical systems. I did
it with IDE drives, but I don't see why it won't work with SCSI/SATA.

The first thing you need is to make sure the partition tables are
identical on both drives. (you probably don't, but it'll be much easier)

So I started with my good system, and had a copy of the partition table on
hda:

  # sfdisk -d /dev/hda > ~hda.part

Made sure all partitions were insync, then shut it down and remove hdb,
and replace it with a new blank disk of the same size.

It booted just fine, with all partitions degraded.

Put the parittion table on the new blank hdb:

  # sfdisk /dev/hdb < ~/hda.part

then I hot-added each partition. eg:

  # mdadm --add /dev/md1 /dev/hdb1

and so on.

And that's it.

you have in your hand a working disk to put (as hda) into a new system, so
just put in in and repeat the above, then you have 2 working systems. Shut
them down and remove the hdb's and you have 2 degraded systems and 2 new
masters to repeat the process.

It's time consuming, but it will work.

One thing you will need to do is change the hostname on each new system
you bring up, and IP address (if not by DHCP).

> It would mean, of course,
> that the UUIDs would be the same on each system. Is that bad? Is there
> any risk here?

Probably not.

> -- I know there was a lot of discussion on the list a while back about
> whether or not to mirror SWAP space. Was there ever any conclusion?

If you don't mirror (or RAID) swap, and a sector in the swap partition
goes faulty, then it's game over, so if you have swap then it must be
raided. I've put swap on RAID1/5 and 6. It might be sub-optimal on RAID-5
and 6, but hey ...

Gordon
