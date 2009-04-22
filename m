From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: what superblock to use
Date: Wed, 22 Apr 2009 11:26:00 -0500
Message-ID: <20090422162601486.TLKI2063@cdptpa-omta04.mail.rr.com>
References: <49EE02DB.6020407@zytor.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EE02DB.6020407@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > No, raid6 survives the simultaneous failure of two disks.
> > Raid5 survives the simultaneous failure of one disk only. Even with a
> > hot-spare, after this failure you have a time frame where the spare is
> > synching and your array has no redundancy left. Thus, nearly every other
> > disk failure (except a failure on the synching spare) within this time
> > frame kills your array.
> >
> 
> It's worth noting that a failure mode that is getting increasingly
> frequently reported is the failure of a drive *during sync*.  I suspect
> that the cause is that synchronization puts different stresses on the
> drives than normal operation.

Yes, that, and with both drives and RAID arrays growing larger, it's taking
longer for arrays to re-sync, meaning a failure during any random time
period is going to be more likely to fall during a sync.  When I first
installed a RAID system on my server, it only took a few hours to sync the
320G array.  Now it can take up to 3 days to synch the 8T array.

