From: Neil Brown <neilb@suse.de>
Subject: Re: FailSpare event?
Date: Fri, 12 Jan 2007 09:59:15 +1100
Message-ID: <17830.49475.108136.376489@notabene.brown>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<20070111223628.GU32386@mikee.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike on Thursday January 11
Sender: linux-raid-owner@vger.kernel.org
To: Mike <mikee@mikee.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 11, mikee@mikee.ath.cx wrote:
> 
> So I'm ok for the moment? Yes, I need to find the error and fix everything
> back to the (S) state.

Yes, OK for the moment.

> 
> The messages in $HOST:/var/log/messages for the time of the email are:
> 
> Jan 11 16:04:25 elo kernel: sd 2:0:4:0: SCSI error: return code = 0x8000002
> Jan 11 16:04:25 elo kernel: sde: Current: sense key: Hardware Error
> Jan 11 16:04:25 elo kernel:     Additional sense: Internal target failure
> Jan 11 16:04:25 elo kernel: Info fld=0x10b93c4d
> Jan 11 16:04:25 elo kernel: end_request: I/O error, dev sde, sector 280575053
> Jan 11 16:04:25 elo kernel: raid5: Disk failure on sde2, disabling device. Operation continuing on 5 devices

Given the sector number it looks likely that it was a superblock
update.
No idea how bad an 'internal target failure' is.  Maybe powercycling
the drive would 'fix' it, maybe not.

> 
> On AIX boxes I can blink the drives to identify a bad/failing device. Is there
> a way to blink the drives in linux?

Unfortunately not.

NeilBrown
