From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: RFC - new raid superblock layout for md driver
Date: Wed, 11 Dec 2002 10:07:52 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15862.29640.272212.693445@notabene.cse.unsw.edu.au>
References: <4D618F6493CE064A844A5D496733D66703158F@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Bene on Tuesday December 10
To: Martin Bene <martin.bene@icomedias.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 10, martin.bene@icomedias.com wrote:
> Hi Neil,
> 
> > When a raid1 array is out of sync, it doesn't mean anything to say
> > which disc is out of sync.  They all are, with each other...
> > Nonetheless, the per-device stateflags have an 'in-sync' bit which can
> > be set or cleared as appropriate.
> 
> Not quite, esp. not in the case of interrupted sync. in that case you've got
> one disk with valid data and another disk known to contain nothing usable.
> 
> Disk1		Disk2
> aaaaaaaaaa	aaaaabbbbb
> 
> If the information that disk2 is currently NOT usable isn't preserved bad
> things might happen on resume - I don't think a result of 
> 
> Disk1		Disk2
> aaaaabbbbb	aaaaabbbbb
> 
> after resync finishes would make anyone especially happy :-)

I think we are using different terminology.
There are two similar but different proccesses that a raid1 array
can go though: resync and recovery.  
Resync happens after an unclean shutdown.  Most of the data is exactly
the same of both (all) drives.  In the few cases of differences, it is
not meaningful to say which is correct.  Hopefully the file filesystem
will be careful about using this data (either through journal
techniques or via fsck).  At start-up you have to arbitrarily choose
one, and it really doesn't matter which one, and make sure that the
other drive(s) have the same data.

Recovery happens after a drive has failed and a spare is being build.
This is the case you seem to be talking about.  I don't call it
resync, and neither does /proc/mdstat.  We call it 'recovery'.
In this case, you obviously need to know which drive is being
recoverred on-to.
In the 0.90.0 superblock, this is done by leaving it marked as a spare
until the rebuild in complete.
In the new version-1 superblock this id done by using a per-device
'in-sync' flag.
The 2.5 code already uses this model, but writes out 0.90.0
superblocks using the old model for compatability.

So I stand by what I said.  "When an array is out of sync, it doesn't
mean anything to say which disc is out of sync."  It is still possibly
to have a single disc being out-of-sync (it was spare and is being
recovered) but this is a different concept from an array being
out-of-sync.

(raid5 obviously has similar concepts.  When the array is out of sync,
you have to rebuild the parity.  When a drive is out of sync, you have
to rebuild that drive)

NeilBrown
