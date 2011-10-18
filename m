From: Andrei Warkentin <awarkentin@vmware.com>
Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental
 recovery.
Date: Tue, 18 Oct 2011 13:15:27 -0700 (PDT)
Message-ID: <1009697343.60005.1318968927271.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <339397930.59570.1318968365639.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <339397930.59570.1318968365639.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Andrei Warkentin <andreiw@vmware.com>
List-Id: linux-raid.ids

----- Original Message -----
> From: "Andrei Warkentin" <awarkentin@vmware.com>
> To: "NeilBrown" <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>
> Sent: Tuesday, October 18, 2011 4:06:05 PM
> Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental recovery.
> 
> Hi Neil,
> 
> ----- Original Message -----
> > From: "Andrei Warkentin" <awarkentin@vmware.com>
> > To: "NeilBrown" <neilb@suse.de>
> > Cc: linux-raid@vger.kernel.org, "Andrei Warkentin"
> > <andreiw@vmware.com>
> > Sent: Tuesday, October 18, 2011 1:07:24 PM
> > Subject: Re: [PATCH] MD: Allow restarting an interrupted
> > incremental recovery.
> > 
> > > Also I realised that clearing saved_raid_disk when an array is
> > > not
> > > degraded
> > > is no longer enough.  We also need to clear it when the device
> > > becomes
> > > In_sync.
> > > Consider a 3-drive RAID1 with two drives missing.  You add back
> > > one
> > > of them
> > > and when it is recovered it needs saved_raid_disk cleared so that
> > > the
> > > superblock gets written out.
> > > 
> > > So below is what I applied.
> > > 
> > 
> > Wouldn't all drives being In_sync imply the array is not degraded -
> > i.e. can the
> > check for a degraded array be omitted then, at all? I.e. if after
> > the
> > resync the
> > In_sync bit is set - drop saved_raid_role.
> > 
> 
> Come to think of it - checking for !mddev->degraded might not be a
> good idea at all. After all, you
> could imagine a situation where in a RAID1 array with A and B, A is
> recovered from B and then B goes away before
> the SBs are flushed due to resync finishing - you would still want
> A's SB to be flushed, even if array is degraded.
> 
> Otherwise you'll end up with another incremental rebuilding A, and
> lost/inconsistent data after array became degraded (since it was
> going to A, but we never wrote out its SB, since array is degraded).
> 

Errr, I confused myself. This is exactly why you added the check for In_sync.
OTOH, isn't the mddev->degraded now superflous - i.e. if all disks are In_sync,
there is no need to check for degraded, right?

A
