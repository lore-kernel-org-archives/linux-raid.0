From: Eli Stair <estair@ilm.com>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Tue, 10 Oct 2006 17:00:02 -0700
Message-ID: <452C3402.9070100@ilm.com>
References: <20061005171233.6542.patches@notabene><1061005071326.6578@suse.de><45255C54.6060608@ilm.com><4526DBCE.6070906@ilm.com> <17706.65210.999441.373846@cse.unsw.edu.au> <452C05AF.2070807@ilm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020903090303010109040907"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <452C05AF.2070807@ilm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020903090303010109040907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


In testing this some more, I've determined that (always with this 
raid10.c patch, sometimes without) the kernel is not recognizing 
marked-faulty drives when they're added back to the array.  It appears 
to be some bit that is flagged and (I assume) normally cleared when that 
drive is re-added as an array member.

If I zero the device (I'm assuming it's the wiping of the mdadm 
superblock), it will be marked upon issuing 'mdadm /dev/md0 -a 
/dev/dm-0' as "spare" instead of "faulty-spare".  This behaviour has 
been erratic for a while, and I'm not sure if I'm seeing a bug or if I 
am working under the wrong presumption with inappropriate actions on my 
part.

When a drive is either manually marked "failed" or is automatically 
tagged during a failure, is the expected user action to zero the 
(original or replacement) drive before doing an 'add'?  Should the 
kernel recognize that the drive was removed, and that the 'add' should 
clear any "faulty" or "failed" state?


/eli

PS - In the process of figuring out when this occurs and how to work 
around it, I just hacked up this shell script that takes care of 
removing the device from the array, zeroing it, re-reading/scanning the 
disk and adding it back in, depending on the function that is called.




Eli Stair wrote:
> 
> Thanks Neil,
> 
> I just gave this patched module a shot on four systems.  So far, I
> haven't seen the device number inappropriately increment, though as per
>   a mail I sent a short while ago that seemed remedied by using the 1.2
> superblock, for some reason.  However, it appears to have introduced a
> new issue, and another is unresolved by it:
> 
> 
> 
> // BUG 1
> The single-command syntax to fail and remove a drive is still failing, I
> do not know if this is somehow contributing to the further (new) issues
> below:
> 
>    [root@gtmp06 tmp]# mdadm /dev/md0 --fail /dev/dm-0 --remove /dev/dm-0
>    mdadm: set /dev/dm-0 faulty in /dev/md0
>    mdadm: hot remove failed for /dev/dm-0: Device or resource busy
> 
>    [root@gtmp06 tmp]# mdadm /dev/md0 --remove /dev/dm-0
>    mdadm: hot removed /dev/dm-0
> 
> 
> // BUG 2
> Now, upon adding or re-adding a "fail...remove"'d drive, it is not used
> for resync.  I realized previously that added drives weren't re-synced
> until the existing array build was done, then they were grabbed.  This
> however is a clean/active array that is rejecting the drive.
> 
> I've performed this identically on both a clean & active array, as well
> as a newly-created (resync'ing) array, to the same effect.  Even after
> rebuild or reboot, the removed drive isn't taken back and remains listed
> as a "faulty spare", with dmesg indicating that it is "non-fresh".
> 
> 
> 
> 
> // DMESG:
> 
> md: kicking non-fresh dm-0 from array!
> 
> 
> // ARRAY status 'mdadm -D /dev/md0'
> 
>            State : active, degraded
>   Active Devices : 13
> Working Devices : 13
>   Failed Devices : 1
>    Spare Devices : 0
> 
>           Layout : near=1, offset=2
>       Chunk Size : 512K
> 
>             Name : 0
>             UUID : 05c2faf4:facfcad3:ba33b140:100f428a
>           Events : 22
> 
>      Number   Major   Minor   RaidDevice State
>         0     253        1        0      active sync   /dev/dm-1
>         1     253        2        1      active sync   /dev/dm-2
>         2     253        5        2      active sync   /dev/dm-5
>         3     253        4        3      active sync   /dev/dm-4
>         4     253        6        4      active sync   /dev/dm-6
>         5     253        3        5      active sync   /dev/dm-3
>         6     253       13        6      active sync   /dev/dm-13
>         7       0        0        7      removed
>         8     253        7        8      active sync   /dev/dm-7
>         9     253        8        9      active sync   /dev/dm-8
>        10     253        9       10      active sync   /dev/dm-9
>        11     253       11       11      active sync   /dev/dm-11
>        12     253       10       12      active sync   /dev/dm-10
>        13     253       12       13      active sync   /dev/dm-12
> 
>         7     253        0        -      faulty spare   /dev/dm-0
> 
> 
> 
> 
> Let me know what more I can do to help track this down.  I'm reverting
> this patch, since it is behaving less-well than before.  Will be happy
> to try others.
> 
> Attached are typescript of the drive remove/add sessions and all output.
> 
> 
> /eli
> 
> 
> Neil Brown wrote:
>  > On Friday October 6, estair@ilm.com wrote:
>  >  >
>  >  > This patch has resolved the immediate issue I was having on 2.6.18 
> with
>  >  > RAID10.  Previous to this change, after removing a device from the 
> array
>  >  > (with mdadm --remove), physically pulling the device and
>  >  > changing/re-inserting, the "Number" of the new device would be
>  >  > incremented on top of the highest-present device in the array.  
> Now, it
>  >  > resumes its previous place.
>  >  >
>  >  > Does this look to be 'correct' output for a 14-drive array, which 
> dev 8
>  >  > was failed/removed from then "add"'ed?  I'm trying to determine 
> why the
>  >  > device doesn't get pulled back into the active configuration and
>  >  > re-synced.  Any comments?
>  >
>  > Does this patch help?
>  >
>  >
>  >
>  > Fix count of degraded drives in raid10.
>  >
>  >
>  > Signed-off-by: Neil Brown <neilb@suse.de>
>  >
>  > ### Diffstat output
>  >  ./drivers/md/raid10.c |    2 +-
>  >  1 file changed, 1 insertion(+), 1 deletion(-)
>  >
>  > diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
>  > --- .prev/drivers/md/raid10.c   2006-10-09 14:18:00.000000000 +1000
>  > +++ ./drivers/md/raid10.c       2006-10-05 20:10:07.000000000 +1000
>  > @@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
>  >                 disk = conf->mirrors + i;
>  >
>  >                 if (!disk->rdev ||
>  > -                   !test_bit(In_sync, &rdev->flags)) {
>  > +                   !test_bit(In_sync, &disk->rdev->flags)) {
>  >                         disk->head_position = 0;
>  >                         mddev->degraded++;
>  >                 }
>  >
>  >
>  > NeilBrown
>  >
> 


--------------020903090303010109040907
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="mdadm-replace-drive.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-replace-drive.sh"

#!/bin/sh

MODE=$1
ARRAY=$2
DRIVE=$3

alias logger="logger -s -t mdadm_replace"

function DISK_REMOVE {

  mdadm -D $ARRAY | grep -E "${DRIVE}$" > /dev/null
  MD_DEV_PRESENT="$?"
  if [ "$MD_DEV_PRESENT" == "0" ] ; then
    echo "// SETTING DRIVE($DRIVE) STATE TO FAULTY "
    echo mdadm $ARRAY -f $DRIVE
    mdadm $ARRAY -f $DRIVE
    sleep 5
    echo "// REMOVING DRIVE($DRIVE) FROM ARRAY($ARRAY) "
    echo mdadm $ARRAY -r $DRIVE
    mdadm $ARRAY -r $DRIVE
    MD_DEV_REMOVE="$?"
    if [ "$MD_DEV_REMOVE" != "0" ] ; then
      echo "// DEVICE ($DRIVE) FAILED TO REMOVE, EXITING UNCLEANLY! "
      exit 1
    fi

  else
    echo "// DEVICE ($DRIVE) NOT LISTED, EXITING (PERHAPS REMOVED ALREADY...) "
    return 1
  fi

} #/FUNCTION DISK_REMOVE

function DISK_READMIT {

  echo "// ZEROING DRIVE BEFORE ADMITTING BACK TO ARRAY "
  # set 1MB blocksize for 'dd'
  BS="1048576"
  # get blockdev size in bytes:
  DISK_BYTES=`fdisk -l ${DRIVE} 2>/dev/null | grep bytes | head -1 | awk '{print $5}'`
  # calculate for DD, to write at offset 64MB from the end of device -> end of device
  (( DISK_BYTES_OFFSET=( $DISK_BYTES / $BS ) - 64 ))

  # zero 64MB at start of drive
  dd if=/dev/zero of=${DRIVE} bs=1M count=64
  DD_ERR=$?
  # check and make sure we are writing to the drive, else exit with an error
  if [ "${DD_ERR}" != "0" ] ; then
    echo "COULD NOT ZERO DEVICE ${DRIVE}, EXITING WITH ERROR ${DD_ERR} "
    exit 1
  fi
  # zero drive starting at offset 64MB from end until it hits the wall
  dd if=/dev/zero of=${DRIVE} bs=1M seek=$DISK_BYTES_OFFSET

  # hackey-like reload of device now that it's been b0rked:
  echo "// RE-LOADING DRIVE BY KERNEL "
  MASTER=`basename $DRIVE`
  for SLAVE in /sys/block/$MASTER/slaves/* ; do 
    #echo "SLAVE is $SLAVE "
    RDEV=`basename $SLAVE`
    echo 1 > $SLAVE/device/rescan 
    sleep 1
    blockdev --rereadpt /dev/$RDEV >/dev/null 2>&1
  done
  blockdev --rereadpt $DRIVE >/dev/null 2>&1

  # sleep a few to let udev/kernel catch up
  sleep 10

  # add device back to array now:
  echo "// mdadm $ARRAY -a $DRIVE"
  mdadm $ARRAY -a $DRIVE
  MD_ADD_ERR="$?"
  if [ "${MD_ADD_ERR}" != "0" ] ; then
    echo "COULD NOT ADD DEVICE($DRIVE) BACK TO ARRAY($ARRAY), EXITING WITH ERROR ${DD_ERR} "
    exit 1
  fi

  # array now has the replacement drive.  show status and exit:
  echo -e "\n#### ARRAY $ARRAY STATUS: " | logger
  cat /proc/mdstat | logger
  echo -e "\n#### DEVICE $DRIVE STATUS: " | logger
  mdadm --examine $DRIVE | logger
  exit 0

} #/FUNCTION DISK_READMIT


### END SETUP.
### START PROGRAM FLOW:

if [[ (( x"${ARRAY}" == "x" )) &&  (( x"${DRIVE}" == "x" )) ]] ; then

  ### necessary input vals not defined, exit.
  echo "VALUES NOT SET "
  exit 1

else

  ### ALL CLEAR, run program
  # function
  $MODE
  
fi


--------------020903090303010109040907--
