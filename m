From: Mike <mikee@mikee.ath.cx>
Subject: Re: FailSpare event?
Date: Thu, 11 Jan 2007 16:36:28 -0600
Message-ID: <20070111223628.GU32386@mikee.ath.cx>
References: <eo6cn8$5se$1@sea.gmane.org> <17830.47341.560158.521091@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17830.47341.560158.521091@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 12 Jan 2007, Neil Brown might have said:

> On Thursday January 11, mikee@mikee.ath.cx wrote:
> > Can someone tell me what this means please? I just received this in
> > an email from one of my servers:
> > 
> ....
> 
> > 
> > A FailSpare event had been detected on md device /dev/md2.
> > 
> > It could be related to component device /dev/sde2.
> 
> It means that mdadm has just noticed that /dev/sde2 is a spare and is faulty.
> 
> You would normally expect this if the array is rebuilding a spare and
> a write to the spare fails however...
> 
> > 
> > md2 : active raid5 sdf2[4] sde2[5](F) sdd2[3] sdc2[2] sdb2[1] sda2[0]
> > 560732160 blocks level 5, 256k chunk, algorithm 2 [5/5] [UUUUU]
> 
> That isn't the case here - your array doesn't need rebuilding.
> Possible a superblock-update failed.  Possibly mdadm only just started
> monitoring the array and the spare has been faulty for some time.
> 
> > 
> > Does the email message mean drive sde2[5] has failed? I know the sde2 refers
> > to the second partition of /dev/sde. Here is the partition table
> 
> It means that md thinks sde2 cannot be trusted.  To find out why you
> would need to look at kernel logs for IO errors.
> 
> > 
> > I have partition 2 of drive sde as one of the raid devices for md. Does the (S)
> > on sde3[2](S) mean the device is a spare for md1 and the same for md0?
> > 
> 
> Yes, (S) means the device is spare.  You don't have (S) next to sde2
> on md2 because (F) (failed) overrides (S).
> You can tell by the position [5], that it isn't part of the array
> (being a 5 disk array, the active positions are 0,1,2,3,4).
> 
> NeilBrown
> 

Thanks for the quick response.

So I'm ok for the moment? Yes, I need to find the error and fix everything
back to the (S) state.

The messages in $HOST:/var/log/messages for the time of the email are:

Jan 11 16:04:25 elo kernel: sd 2:0:4:0: SCSI error: return code = 0x8000002
Jan 11 16:04:25 elo kernel: sde: Current: sense key: Hardware Error
Jan 11 16:04:25 elo kernel:     Additional sense: Internal target failure
Jan 11 16:04:25 elo kernel: Info fld=0x10b93c4d
Jan 11 16:04:25 elo kernel: end_request: I/O error, dev sde, sector 280575053
Jan 11 16:04:25 elo kernel: raid5: Disk failure on sde2, disabling device. Operation continuing on 5 devices

This is a dell box running Fedora Core with recent patches. It is a production
box so I do not patch each night.

On AIX boxes I can blink the drives to identify a bad/failing device. Is there
a way to blink the drives in linux?

Mike
