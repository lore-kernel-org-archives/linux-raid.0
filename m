From: dean gaudet <dean@arctic.org>
Subject: Re: Resize on dirty array?
Date: Thu, 10 Aug 2006 10:44:11 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>
References: <44D7DC93.2070905@net1plus.com> <17623.57067.835826.446152@cse.unsw.edu.au>
  <44D8E535.9080208@net1plus.com> <17625.24594.568139.430440@cse.unsw.edu.au>
  <44D9C6F5.7070501@net1plus.com> <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
 <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
 <44D9E41C.4050608@net1plus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D9E41C.4050608@net1plus.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

suggestions:

- set up smartd to run long self tests once a month.   (stagger it every 
  few days so that your disks aren't doing self-tests at the same time)

- run 2.6.15 or later so md supports repairing read errors from the other 
  drives...

- run 2.6.16 or later so you get the check and repair sync_actions in
  /sys/block/mdX/md/sync_action (i think 2.6.16.x still has a bug where
  you have to echo a random word other than repair to sync_action to get
  a repair to start... wrong sense on a strcmp, fixed in 2.6.17).

- run nightly diffs of smartctl -a output on all your drives so you see 
  when one of them reports problems in the smart self test or otherwise
  has a Current_Pending_Sectors or Realloc event... then launch a
  repair sync_action.

- proactively replace your disks every couple years (i prefer to replace 
  busy disks before 3 years).

-dean

On Wed, 9 Aug 2006, James Peverill wrote:

> 
> In this case the raid WAS the backup... however it seems it turned out to be
> less reliable than the single disks it was supporting.  In the future I think
> I'll make sure my disks have varying ages so they don't fail all at once.
> 
> James
> 
> > > RAID is no excuse for backups.
> PS: <ctrl><pgup>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
