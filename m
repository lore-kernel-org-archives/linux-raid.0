From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 problem can't add remove or mark faulty -- it did work
Date: Sun, 27 Mar 2005 17:26:44 +1000
Message-ID: <16966.24628.475966.719272@cse.unsw.edu.au>
References: <42461C47.8090706@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from rrk on Saturday March 26
Sender: linux-raid-owner@vger.kernel.org
To: rrk <rrk@prairie.lakes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 26, rrk@prairie.lakes.com wrote:
> i have a strange problem -- can't get a fully funtional 2 drive raid 
> back up running-- it may or may not be a drive bios interaction don't 
> know. none of the mdadm manage functions will work add remove or mark faulty
> i have purged and reinstalled the mdadm package twice.
> 
> below is all the info i could think  of .   the kernel is 2.6.10 
> patched  -- stock kanotix
> either drive will boot and the behavior is the same no matter which one 
> is active

For future reference, extra information which would be helpful
includes
   cat /proc/mdstat
   mdadm -D /dev/md0
  and any 'dmesg' messages that are generated when 'mdadm' fails.

It appears that hda1 and hdc1 are parts of the raid1, and hdc1 is the
'freshest' part so when you boot, the array is assembled with just one
drive: hdc1.  hda1 is not included because it appears to be out of
date, and so presumably failed at some time.

The thing that should be done is to add hda1 with
   mdadm /dev/md0 -a /dev/hda1

It appears that you tried this and it failed.  When it failed there
should have been kernel messages generated.  I need to see these.

> what happens when i try a hot add remove or set faulty
>  
> root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hda1
> mdadm: hot add failed for /dev/hda1: Invalid argument

This should have worked, but didn't.  The kernel messages should
indicate why.


> root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hdc1
> mdadm: hot add failed for /dev/hdc1: Invalid argument
> 

hdc1 is already part of md0. Adding it is meaningless.


> root@crm_svr:/home/rob# mdadm /dev/md0 -r /dev/hda1
> mdadm: hot remove failed for /dev/hda1: No such device or address

You cannot remove hda1 because it isn't part of the array.

> root@crm_svr:/home/rob# mdadm /dev/md0 -r /dev/hdc1
> mdadm: hot remove failed for /dev/hdc1: Device or resource busy
> 

You cannot remove hdc1 because it is actively in use in the array.
You can only removed failed drives or spares.


> root@crm_svr:/home/rob# mdadm /dev/md0 -f /dev/hda1
> mdadm: set device faulty failed for /dev/hda1:  No such device

You cannot fail hda1 because it isn't part of md0.

> root@crm_svr:/home/rob# mdadm /dev/md0 -f /dev/hdc1
> mdadm: set /dev/hdc1 faulty in /dev/md0

Ooops... you just failed the only drive in the raid1 array, md0 will
no longer be functional... until you reboot and the array gets
re-assembled.  Failing a drive does not write anything to it, so you
won't have hurt any drive by doing this, just made the array stop
working for now.


NeilBrown
