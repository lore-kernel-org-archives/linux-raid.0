From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Mon, 20 May 2002 21:26:35 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
References: <CPEAKNIMKMJOCFPEOBGACECFCFAA.cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Calvin Webster on Sunday May 19
To: cwebster@ec.rr.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 19, cwebster@ec.rr.com wrote:
> Looking for help from list members in resolving software RAID problems.

Here is the help:

1/  You seem to have two copies of raid5.o which seems to be confusing
    modprobe.  
    I don't know why, but in one instance it tried to load
      /lib/raid5.o
    and gets :unresolved symbol md_unregister_thread_R4ba824f9

    The other time it correctly loads
      /lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o

    I suggest removing /lib/raid5.c

2/ 2.4 raid is *not* upwards compatable with patched 2.2 raid on Sparc64
   or any architecture that requires a 64bit integer to be 64bit
   aligned  instead of just 32bit aligned.  
   I'm sorry, but this was a bug in the raid patches and it is not
   practical to reliably detect raid devices that were built
   badly because of this bug.  The bug results in the on-disc
   superblock being laid out wrongly.

   You will need to remake the array for 2.4.
   If you remake the array correctly, you will not lose any
   data.

   Alternately, if you are feeling adventurous, you could download
   and compile mdadm 1.0.1 from
     http://www.cse.unsw.edu.au/~neilb/source/mdadm/

   For each device that should be part of the array (e.g. /dev/sda1)
   run
      mdadm --examine /dev/sda1
   This should show you some sensible information up to the Checksum,
   and then bad information after that.
   Then run
      mdadm --examine --sparc2.2  /dev/sda1
   This should show you the same sensible information, and then
   sensible information after the Checksum as well.
   If it does, then run
      mdadm --examine --sparc2.2update /dev/sda1
   and this should show the same sensible information, and then update
   the superblock on the device to have this information too.
   After this,
      mdadm --examine --sparc2.2 /dev/sda1
   should show the correct information.

   If this works, you can then run the same command on the order
   devices, and then assemble the array with
      mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 ...
   or whatever your actual device names are.

   Note: I have not tested this code, but it looks OK.
   If you try it and something goes wrong, then give me as much
   information as you can and I will do my best to make sure you get
   your data back.

   Note2: --sparc2.2 and --sparc2.2update are not yet documented,
    except in this mail item.
    If you confirm that they work, I will add some documentation.

NeilBrown
