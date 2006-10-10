From: Eli Stair <estair@ilm.com>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Tue, 10 Oct 2006 13:20:29 -0700
Message-ID: <452C008D.8060000@ilm.com>
References: <20061005171233.6542.patches@notabene> A<1061005071326.6578@suse.de> <45255C54.6060608@ilm.com> <4526DBCE.6070906@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4526DBCE.6070906@ilm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Looks like this issue isn't fully resolved after all, after spending 
some time trying to get the re-added drive to sync, I've removed and 
added it again.  This resulted in the previous behaviour I saw, losing 
its original numeric position, and becoming "14".

This now looks 100% repeatable, and appears to look like a race 
condition.  One item of note, is that if I build the array with a 
version 1.2 superblock, this mis-numbering behaviour seems to disappear 
(I've run through it five times since without recurrence).

Doing a single-command fail/remove fails the device but errors on removal:

[root@gtmp03 ~]# mdadm /dev/md0 --fail /dev/dm-13 --remove /dev/dm-13
mdadm: set /dev/dm-13 faulty in /dev/md0
mdadm: hot remove failed for /dev/dm-13: Device or resource busy





     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
        2     253        2        2      active sync   /dev/dm-2
        3     253        3        3      active sync   /dev/dm-3
        4     253        4        4      active sync   /dev/dm-4
        5     253        5        5      active sync   /dev/dm-5
        6     253        6        6      active sync   /dev/dm-6
        7     253        7        7      active sync   /dev/dm-7
        8       0        0        8      removed
        9     253        9        9      active sync   /dev/dm-9
       10     253       10       10      active sync   /dev/dm-10
       11     253       11       11      active sync   /dev/dm-11
       12     253       12       12      active sync   /dev/dm-12
       13     253       13       13      active sync   /dev/dm-13

       14     253        8        -      spare   /dev/dm-8



Eli Stair wrote:
> 
> This patch has resolved the immediate issue I was having on 2.6.18 with
> RAID10.  Previous to this change, after removing a device from the array
> (with mdadm --remove), physically pulling the device and
> changing/re-inserting, the "Number" of the new device would be
> incremented on top of the highest-present device in the array.  Now, it
> resumes its previous place.
> 
> Does this look to be 'correct' output for a 14-drive array, which dev 8
> was failed/removed from then "add"'ed?  I'm trying to determine why the
> device doesn't get pulled back into the active configuration and
> re-synced.  Any comments?
> 
> Thanks!
> 
> /eli
> 
> For example, currently when device dm-8 is removed it shows up like this:
> 
> 
> 
>      Number   Major   Minor   RaidDevice State
>         0     253        0        0      active sync   /dev/dm-0
>         1     253        1        1      active sync   /dev/dm-1
>         2     253        2        2      active sync   /dev/dm-2
>         3     253        3        3      active sync   /dev/dm-3
>         4     253        4        4      active sync   /dev/dm-4
>         5     253        5        5      active sync   /dev/dm-5
>         6     253        6        6      active sync   /dev/dm-6
>         7     253        7        7      active sync   /dev/dm-7
>         8       0        0        8      removed
>         9     253        9        9      active sync   /dev/dm-9
>        10     253       10       10      active sync   /dev/dm-10
>        11     253       11       11      active sync   /dev/dm-11
>        12     253       12       12      active sync   /dev/dm-12
>        13     253       13       13      active sync   /dev/dm-13
> 
>         8     253        8        -      spare   /dev/dm-8
> 
> 
> Previously however, it would come back with the "Number" as 14, not 8 as
> it should.  Shortly thereafter things got all out of whack, in addition
> to just not working properly :)  Now I've just got to figure out how to
> get the re-introduced drive to participate in the array again like it
> should.
> 
> Eli Stair wrote:
>  >
>  >
>  > I'm actually seeing similar behaviour on RAID10 (2.6.18), where after
>  > removing a drive from an array re-adding it sometimes results in it
>  > still being listed as a faulty-spare and not being "taken" for resync.
>  > In the same scenario, after swapping drives, doing a fail,remove, then
>  > an 'add' doesn't work, only a re-add will even get the drive listed by
>  > MDADM.
>  >
>  >
>  > What's the failure mode/symptoms that this patch is resolving?
>  >
>  > Is it possible this affects the RAID10 module/mode as well?  If not,
>  > I'll start a new thread for that.  I'm testing this patch to see if it
>  > does remedy the situation on RAID10, and will update after some
>  > significant testing.
>  >
>  >
>  > /eli
>  >
>  >
>  >
>  >
>  >
>  >
>  >
>  >
>  > NeilBrown wrote:
>  >  > There is a nasty bug in md in 2.6.18 affecting at least raid1.
>  >  > This fixes it (and has already been sent to stable@kernel.org).
>  >  >
>  >  > ### Comments for Changeset
>  >  >
>  >  > This fixes a bug introduced in 2.6.18.
>  >  >
>  >  > If a drive is added to a raid1 using older tools (mdadm-1.x or
>  >  > raidtools) then it will be included in the array without any resync
>  >  > happening.
>  >  >
>  >  > It has been submitted for 2.6.18.1.
>  >  >
>  >  >
>  >  > Signed-off-by: Neil Brown <neilb@suse.de>
>  >  >
>  >  > ### Diffstat output
>  >  >  ./drivers/md/md.c |    1 +
>  >  >  1 file changed, 1 insertion(+)
>  >  >
>  >  > diff .prev/drivers/md/md.c ./drivers/md/md.c
>  >  > --- .prev/drivers/md/md.c       2006-09-29 11:51:39.000000000 +1000
>  >  > +++ ./drivers/md/md.c   2006-10-05 16:40:51.000000000 +1000
>  >  > @@ -3849,6 +3849,7 @@ static int hot_add_disk(mddev_t * mddev,
>  >  >         }
>  >  >         clear_bit(In_sync, &rdev->flags);
>  >  >         rdev->desc_nr = -1;
>  >  > +       rdev->saved_raid_disk = -1;
>  >  >         err = bind_rdev_to_array(rdev, mddev);
>  >  >         if (err)
>  >  >                 goto abort_export;
>  >  > -
>  >  > To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in
>  >  > the body of a message to majordomo@vger.kernel.org
>  >  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  >  >
>  >
>  > -
>  > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

