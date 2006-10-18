From: Eli Stair <estair@ilm.com>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Wed, 18 Oct 2006 15:18:48 -0700
Message-ID: <4536A848.8020908@ilm.com>
References: <20061005171233.6542.patches@notabene><1061005071326.6578@suse.de><45255C54.6060608@ilm.com><4526DBCE.6070906@ilm.com> <17706.65210.999441.373846@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.65210.999441.373846@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


FYI, I'm testing 2.6.18.1 and noticed this mis-numbering of RAID10
members issue is still extant.  Even with this fix applied to raid10.c, 
I am still seeing repeatable issues with devices assuming a "Number" 
greater than that which they had when removed from a running array.

Issue 1)

I'm seeing inconsistencies in the way a drive is marked (and its 
behaviour) during rebuild after it is removed and added.  In this 
instance, the re-added drive is picked up and marked as "spare 
rebuilding".

  Rebuild Status : 20% complete

            Name : 0
            UUID : ab764369:7cf80f2b:cf61b6df:0b13cd3a
          Events : 1

     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
        2     253       10        2      active sync   /dev/dm-10
        3     253       11        3      active sync   /dev/dm-11
        4     253       12        4      active sync   /dev/dm-12
        5     253       13        5      active sync   /dev/dm-13
        6     253        2        6      active sync   /dev/dm-2
        7     253        3        7      active sync   /dev/dm-3
        8     253        4        8      active sync   /dev/dm-4
        9     253        5        9      active sync   /dev/dm-5
       10     253        6       10      active sync   /dev/dm-6
       11     253        7       11      active sync   /dev/dm-7
       12     253        8       12      active sync   /dev/dm-8
       13     253        9       13      active sync   /dev/dm-9
[root@gtmp02 ~]# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 dm-9[13] dm-8[12] dm-7[11] dm-6[10] dm-5[9] dm-4[8] 
dm-3[7] dm-2[6] dm-13[5] dm-12[4] dm-11[3] dm-10[2] dm-1[1] dm-0[0]
       1003620352 blocks super 1.2 512K chunks 2 offset-copies [14/14] 
[UUUUUUUUUUUUUU]
       [====>................]  resync = 21.7% (218664064/1003620352) 
finish=114.1min speed=114596K/sec




However, on the same configuration, it occasionally is pulled right back 
with a state of "active sync", without indication that it dirty:

Issue 2)

When a device is removed and subsequently added again (after setting 
failed and removing from the array), it SHOULD be set back to the 
"Number" it originally had in the array correct?  In the cases when the 
drive is NOT automatically marked as "active sync" and all members show 
up fine, it is picked up as a spare and rebuild is started, during which 
time it is marked down "_" in the /proc/mdstat date, and "spare 
rebuilding" in mdadm -D output:



When device "Number" 10


// STATE WHEN CLEAN:
            UUID : 6ccd7974:1b23f5b2:047d1560:b5922692

     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
        2     253       10        2      active sync   /dev/dm-10
        3     253       11        3      active sync   /dev/dm-11
        4     253       12        4      active sync   /dev/dm-12
        5     253       13        5      active sync   /dev/dm-13
        6     253        2        6      active sync   /dev/dm-2
        7     253        3        7      active sync   /dev/dm-3
        8     253        4        8      active sync   /dev/dm-4
        9     253        5        9      active sync   /dev/dm-5
       10     253        6       10      active sync   /dev/dm-6
       11     253        7       11      active sync   /dev/dm-7
       12     253        8       12      active sync   /dev/dm-8
       13     253        9       13      active sync   /dev/dm-9


// STATE AFTER FAILURE:
     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
        2       0        0        2      removed
        3     253       11        3      active sync   /dev/dm-11
        4     253       12        4      active sync   /dev/dm-12
        5     253       13        5      active sync   /dev/dm-13
        6     253        2        6      active sync   /dev/dm-2
        7     253        3        7      active sync   /dev/dm-3
        8     253        4        8      active sync   /dev/dm-4
        9     253        5        9      active sync   /dev/dm-5
       10     253        6       10      active sync   /dev/dm-6
       11     253        7       11      active sync   /dev/dm-7
       12     253        8       12      active sync   /dev/dm-8
       13     253        9       13      active sync   /dev/dm-9

        2     253       10        -      faulty spare   /dev/dm-10

// STATE AFTER REMOVAL:
     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
        2       0        0        2      removed
        3     253       11        3      active sync   /dev/dm-11
        4     253       12        4      active sync   /dev/dm-12
        5     253       13        5      active sync   /dev/dm-13
        6     253        2        6      active sync   /dev/dm-2
        7     253        3        7      active sync   /dev/dm-3
        8     253        4        8      active sync   /dev/dm-4
        9     253        5        9      active sync   /dev/dm-5
       10     253        6       10      active sync   /dev/dm-6
       11     253        7       11      active sync   /dev/dm-7
       12     253        8       12      active sync   /dev/dm-8
       13     253        9       13      active sync   /dev/dm-9

// STATE AFTER RE-ADD:
     Number   Major   Minor   RaidDevice State
        0     253        0        0      active sync   /dev/dm-0
        1     253        1        1      active sync   /dev/dm-1
       14     253       10        2      spare rebuilding   /dev/dm-10
        3     253       11        3      active sync   /dev/dm-11
        4     253       12        4      active sync   /dev/dm-12
        5     253       13        5      active sync   /dev/dm-13
        6     253        2        6      active sync   /dev/dm-2
        7     253        3        7      active sync   /dev/dm-3
        8     253        4        8      active sync   /dev/dm-4
        9     253        5        9      active sync   /dev/dm-5
       10     253        6       10      active sync   /dev/dm-6
       11     253        7       11      active sync   /dev/dm-7
       12     253        8       12      active sync   /dev/dm-8
       13     253        9       13      active sync   /dev/dm-9







/eli


// raid10.c:

         for (i = 0; i < conf->raid_disks; i++) {

                 disk = conf->mirrors + i;

                 if (!disk->rdev ||
                     !test_bit(In_sync, &rdev->flags)) {
                         disk->head_position = 0;
                         mddev->degraded++;
                 }
         }

// END raid10.c




Neil Brown wrote:
> On Friday October 6, estair@ilm.com wrote:
>  >
>  > This patch has resolved the immediate issue I was having on 2.6.18 with
>  > RAID10.  Previous to this change, after removing a device from the array
>  > (with mdadm --remove), physically pulling the device and
>  > changing/re-inserting, the "Number" of the new device would be
>  > incremented on top of the highest-present device in the array.  Now, it
>  > resumes its previous place.
>  >
>  > Does this look to be 'correct' output for a 14-drive array, which dev 8
>  > was failed/removed from then "add"'ed?  I'm trying to determine why the
>  > device doesn't get pulled back into the active configuration and
>  > re-synced.  Any comments?
> 
> Does this patch help?
> 
> 
> 
> Fix count of degraded drives in raid10.
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/raid10.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
> --- .prev/drivers/md/raid10.c   2006-10-09 14:18:00.000000000 +1000
> +++ ./drivers/md/raid10.c       2006-10-05 20:10:07.000000000 +1000
> @@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
>                 disk = conf->mirrors + i;
> 
>                 if (!disk->rdev ||
> -                   !test_bit(In_sync, &rdev->flags)) {
> +                   !test_bit(In_sync, &disk->rdev->flags)) {
>                         disk->head_position = 0;
>                         mddev->degraded++;
>                 }
> 
> 
> NeilBrown
> 


