From: Neil Brown <neilb@suse.de>
Subject: Re: Bad drive discovered during raid5 reshape
Date: Tue, 30 Oct 2007 17:29:15 +1100
Message-ID: <18214.53051.652280.492087@notabene.brown>
References: <47258776.9020601@sisna.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kyle Stuart on Monday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Stuart <kstuart@sisna.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 29, kstuart@sisna.com wrote:
> Hi,
> I bought two new hard drives to expand my raid array today and
> unfortunately one of them appears to be bad. The problem didn't arise
> until after I attempted to grow the raid array. I was trying to expand
> the array from 6 to 8 drives. I added both drives using mdadm --add
> /dev/md1 /dev/sdb1 which completed, then mdadm --add /dev/md1 /dev/sdc1
> which also completed. I then ran mdadm --grow /dev/md1 --raid-devices=8.
> It passed the critical section, then began the grow process.
> 
> After a few minutes I started to hear unusual sounds from within the
> case. Fearing the worst I tried to cat /proc/mdstat which resulted in no
> output so I checked dmesg which showed that /dev/sdb1 was not working
> correctly. After several minutes dmesg indicated that mdadm gave up and
> the grow process stopped. After googling around I tried the solutions
> that seemed most likely to work, including removing the new drives with
> mdadm --remove --force /dev/md1 /dev/sd[bc]1 and rebooting after which I
> ran mdadm -Af /dev/md1. The grow process restarted then failed almost
> immediately. Trying to mount the drive gives me a reiserfs replay
> failure and suggests running fsck. I don't dare fsck the array since
> I've already messed it up so badly. Is there any way to go back to the
> original working 6 disc configuration with minimal data loss? Here's
> where I'm at right now, please let me know if I need to include any
> additional information.

Looks like you are in real trouble.  Both the drives seem bad in some
way.  If it was just sdc that was failing it would have picked up
after the "-Af", but when it tried, sdb gave errors.

Have two failed devices in a RAID5 is not good!

Your best bet goes like this:

  The reshape has started and got up to some point.  The data
  before that point is spread over 8 drives.  The data after is over
  6.
  We need to restripe the 8drive data back to 6 drives.  This can be
  done with the test_stripe tool that can be built from the mdadm
  source. 

  1/ Find out how far the reshape progressed, by using "mdadm -E" on
     one of the devices.
  2/ use something like
        test_stripe save /some/file 8 $chunksize 5 2 0 $length  /dev/......

     If you get all the args right, this should copy the data from
     the array into /some/file.
     You could possibly do the same thing by assembling the array 
     read-only (set /sys/modules/md_mod/parameters/start_ro to 1)
     and 'dd' from the array.  It might be worth doing both and
     checking you get the same result.

  3/ use something like
        test_stripe restore /some/file 6 ..........
     to restore the data to just 6 devices.

  4/ use "mdadm -C" to create the array a-new on the 6 devices.  Make
     sure the order and the chunksize etc is preserved.

     Once you have done this, the start of the array should (again)
     look like the content of /some/file.  It wouldn't hurt to check.

   Then your data would be as much back together as possible.
   You will probably still need to do an fsck, but I think you did the
   right thing in holding off.  Don't do an fsck until you are sure
   the array is writable.

You can probably do the above without using test_stripe by using dd to
copy of the array before you recreate it, then using dd to put the
same data back.  Using test_stripe as well might give you extra
confidence. 

Feel free to ask questions

NeilBrown
