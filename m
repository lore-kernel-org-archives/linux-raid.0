From: Eli Stair <estair@ilm.com>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Thu, 05 Oct 2006 12:26:12 -0700
Message-ID: <45255C54.6060608@ilm.com>
References: <20061005171233.6542.patches@notabene> A<1061005071326.6578@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1061005071326.6578@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I'm actually seeing similar behaviour on RAID10 (2.6.18), where after 
removing a drive from an array re-adding it sometimes results in it 
still being listed as a faulty-spare and not being "taken" for resync. 
In the same scenario, after swapping drives, doing a fail,remove, then 
an 'add' doesn't work, only a re-add will even get the drive listed by 
MDADM.


What's the failure mode/symptoms that this patch is resolving?

Is it possible this affects the RAID10 module/mode as well?  If not, 
I'll start a new thread for that.  I'm testing this patch to see if it 
does remedy the situation on RAID10, and will update after some 
significant testing.


/eli








NeilBrown wrote:
> There is a nasty bug in md in 2.6.18 affecting at least raid1.
> This fixes it (and has already been sent to stable@kernel.org).
> 
> ### Comments for Changeset
> 
> This fixes a bug introduced in 2.6.18.
> 
> If a drive is added to a raid1 using older tools (mdadm-1.x or
> raidtools) then it will be included in the array without any resync
> happening.
> 
> It has been submitted for 2.6.18.1.
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/md.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c       2006-09-29 11:51:39.000000000 +1000
> +++ ./drivers/md/md.c   2006-10-05 16:40:51.000000000 +1000
> @@ -3849,6 +3849,7 @@ static int hot_add_disk(mddev_t * mddev,
>         }
>         clear_bit(In_sync, &rdev->flags);
>         rdev->desc_nr = -1;
> +       rdev->saved_raid_disk = -1;
>         err = bind_rdev_to_array(rdev, mddev);
>         if (err)
>                 goto abort_export;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

