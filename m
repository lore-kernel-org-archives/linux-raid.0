From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: What raid to build on that drives?
Date: Thu, 27 Nov 2003 09:12:13 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16325.9533.231391.210681@notabene.cse.unsw.edu.au>
References: <3229206566.20031126203657@gmx.net>
	<4697.206.81.129.218.1069876742.squirrel@eglifamily.dnsalias.net>
	<13534683912.20031126220814@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Timo Boettcher on Wednesday November 26
To: Timo Boettcher <spida@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 26, spida@gmx.net wrote:
> Hi Dan,
> 
> 
> * Dan Egli , Wednesday, November 26, 2003, 8:59:02 PM:
> 
> >> Hi,
> >>
> >>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
> >>    What possibilities do I have to build a raid on them? I want to be
> >>    able to survive one failed disc, but get as much space and
> >>    performance out of the discs as possible.
> >>
> 
> > Best I can suggest is a raid 5. You'll get 72GB of space, good performance
> > (roughly what you'd get from a sigle drive), and if one of the drives goes
> > south, the other two will keep your raid set up till the drive can be
> > replaced.
> 
> I hoped to integrate all discs in that raid....
> I tried to run raid0 over pairs of the 18GB discs (leavin the fifth
> as spare) and run a raid 5 over these raid0's and the three 36gb
> drives, but that gives me 50mb/s reading as opposed to 100mb/s with
> 8*18GB raid5 on the same machine (three of these discs failed, so I
> got bigger ones). Why did I loose that much performance?
> 

It's hard to say...  It would depend in the chunksizes that you
used and the exact configuration.  Probably is just wasn't keeping all
the drives busy all the time.

The "best configuation" for you depends on things like:
  1/ do you want one large filessytem, or will two filesystems be ok?
  2/ If another 18GB drives dies and you replace it with a 36GB drive,
     will you be keen to incorporate that drive into the array?
  3/ How do you do backups? How big a filesystem can you dump/restore
     to allow for raid reconfiguration?

The only general rule I can give you is to *not* do raid5/raid1 over
raid0/linear.   Always do raid5/raid1 out of real drives, and then if
you want to, join those raids together with raid0/linear.  This gives
much better reliability in the case of failure.

I would probably partition the 36GB drives into 2 18GB partitions,
then use raid5 overall 8 drives (maybe 7 and a hot-spare if you want
that), and then raid1 with a hot spare for the 3 remaining "top-half"
18GB partitions.  Finally raid-linear the raid5 together with the
raid1.

NeilBrown
