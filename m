From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Fri, 9 May 2008 00:42:29 -0400
Message-ID: <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
	 <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
	 <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18467.43895.220708.254814@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Thu, May 8, 2008 at 9:40 PM, Neil Brown <neilb@suse.de> wrote:
>
> On Thursday May 8, snitzer@gmail.com wrote:
>  > On Thu, May 8, 2008 at 2:13 AM, Neil Brown <neilb@suse.de> wrote:
>  > > On Tuesday May 6, snitzer@gmail.com wrote:
>  > >  >
>  > >  > It looks like bitmap_update_sb()'s incrementing of events_cleared (on
>  > >  > behalf of the local member) could be racing with the fact that the NBD
>  > >  > member becomes faulty (whereby making the array degraded).  This
>  > >  > allows the events_cleared to reflect a clean->dirty transition last
>  > >  > occurred before the array became degraded.  My reasoning is: If it was
>  > >  > a clean->dirty transition the bitmap still has the associated dirty
>  > >  > bit set in the local member's bitmap, so using the bitmap to resync is
>  > >  > valid.
>  > >  >
>  > >  > thanks,
>  > >  > Mike
>  > >
>  > >  Thanks for persisting.  I think I understand what is going on now.
>  > >
>  > >  How about this patch?  It is similar to your, but instead of depending
>  > >  on the odd/even state of the event counter, it directly checks the
>  > >  clean/dirty state of the array.
>  >
>  > Hi Neil,
>  >
>  > Your revised patch works great and is obviously cleaner.
>
>  But I'm still not happy with it :-(
>  I suspect there might be other cases where it will still do the wrong
>  thing.
>  The real problem is that we are updating events_cleared to early.  We
>  are setting to the new event counter before that is even written out.
>
>  So I've come up with this patch, which I think more clearly
>  encapsulated what events_cleared means.  It is now set to the current
>  'events' counter immediately before we clear any bit.
>
>  If you could test it, I'd really appreciate it.

Unfortunately my testing with this patch results in a full resync.

Here is the state of the array after shutdown:
# mdadm -X /dev/nbd0 /dev/sdq
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : 7140cc3c:8681416c:12c5668a:984ca55d
          Events : 896
  Events Cleared : 897
           State : OK
       Chunksize : 128 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 52428736 (50.00 GiB 53.69 GB)
          Bitmap : 409600 bits (chunks), 1 dirty (0.0%)

        Filename : /dev/sdq
           Magic : 6d746962
         Version : 4
            UUID : 7140cc3c:8681416c:12c5668a:984ca55d
          Events : 898
  Events Cleared : 897
           State : OK
       Chunksize : 128 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 52428736 (50.00 GiB 53.69 GB)
          Bitmap : 409600 bits (chunks), 0 dirty (0.0%)

# mdadm --examine /dev/nbd0 /dev/sdq
/dev/nbd0:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7140cc3c:8681416c:12c5668a:984ca55d
  Creation Time : Thu May  8 06:55:32 2008
     Raid Level : raid1
  Used Dev Size : 52428736 (50.00 GiB 53.69 GB)
     Array Size : 52428736 (50.00 GiB 53.69 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu May  8 18:07:47 2008
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : df65cb35 - correct
         Events : 0.896


      Number   Major   Minor   RaidDevice State
this     1      43        0        1      active sync write-mostly   /dev/nbd0

   0     0      65        0        0      active sync   /dev/sdq
   1     1      43        0        1      active sync write-mostly   /dev/nbd0


/dev/sdq:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7140cc3c:8681416c:12c5668a:984ca55d
  Creation Time : Thu May  8 06:55:32 2008
     Raid Level : raid1
  Used Dev Size : 52428736 (50.00 GiB 53.69 GB)
     Array Size : 52428736 (50.00 GiB 53.69 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu May  8 18:07:49 2008
          State : clean
Internal Bitmap : present
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : df65c956 - correct
         Events : 0.898


      Number   Major   Minor   RaidDevice State
this     0      65        0        0      active sync   /dev/sdq

   0     0      65        0        0      active sync   /dev/sdq
   1     1       0        0        1      faulty removed

Was I supposed to use this latest patch in combination with your
previous patch (to validate_super)?  Because you'll note that with
your most recent patch nbd0's events (ev1) is still one less than
sdq's events_cleared.  As such the validate_super's "ev1 <
mddev->bitmap->events_cleared" check triggers a full rebuild.

The kernel log shows:
md: md0 stopped.
md: bind<nbd0>
md: bind<sdq>
md: kicking non-fresh nbd0 from array!
md: unbind<nbd0>
md: export_rdev(nbd0)
raid1: raid set md0 active with 1 out of 2 mirrors
md0: bitmap initialized from disk: read 13/13 pages, set 0 bits, status: 0
created bitmap (200 pages) for device md0
Nope!!! ev1 (896) < mddev->bitmap->events_cleared (897)
md: bind<nbd0>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdq
 disk 1, wo:1, o:1, dev:nbd0
md: recovery of RAID array md0
