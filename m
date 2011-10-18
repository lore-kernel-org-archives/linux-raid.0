From: Andrei Warkentin <awarkentin@vmware.com>
Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental
 recovery.
Date: Tue, 18 Oct 2011 10:07:24 -0700 (PDT)
Message-ID: <486504952.50696.1318957644567.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <20111018122239.72685887@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111018122239.72685887@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Andrei Warkentin <andreiw@vmware.com>
List-Id: linux-raid.ids

Hi Neil,

----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Andrei Warkentin" <andreiw@vmware.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Monday, October 17, 2011 9:22:39 PM
> Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental recovery.
> 
> On Mon, 17 Oct 2011 19:22:11 -0400 Andrei Warkentin
> <andreiw@vmware.com>
> wrote:
> 
> > If an incremental recovery was interrupted, a subsequent
> > re-add will result in a full recovery, even though an
> > incremental should be possible (seen with raid1).
> > 
> > Solve this problem by not updating the superblock on the
> > recovering device until array is not degraded any longer.
> > 
> > Cc: Neil Brown <neilb@suse.de>
> > Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> > ---

> Thanks.  I've applied this and pushed it to my for-next branch.
> 
> My current HEAD use pr_debug instead of dprintk so I fixed that.
> 
> Also I realised that clearing saved_raid_disk when an array is not
> degraded
> is no longer enough.  We also need to clear it when the device
> becomes
> In_sync.
> Consider a 3-drive RAID1 with two drives missing.  You add back one
> of them
> and when it is recovered it needs saved_raid_disk cleared so that the
> superblock gets written out.
> 
> So below is what I applied.
> 

Wouldn't all drives being In_sync imply the array is not degraded - i.e. can the
check for a degraded array be omitted then, at all? I.e. if after the resync the
In_sync bit is set - drop saved_raid_role.

A
