From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: O'Reilly RAID Book
Date: Tue, 30 Mar 2004 11:20:43 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87wu53yvtg.fsf@enki.rimspace.net>
References: <1080605251.1695.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30 Mar 2004, Ninti Systems wrote:
> I'm interested in list members opinion on the O'Reilly book 'Managing
> RAID on Linux' by Derek Vadala published in December 2002.

I can't comment on the book, but...

[...]

> I'm almost exclusively interested in RAID1. Would that render 80% of
> the text irrelevant?

...if you are looking at software RAID1, then it probably does.

[...]

> Finally, if anyone could point me to any resources (apart from the
> Software RAID Howto) dealing with building RAID1 arrays on a
> Slackware-type box after the system is already fully installed, that'd
> be great.

I have done this a number of times, and the process of migrating from
single disk to RAID1 (for root) is  (presume root on /dev/hda1):

1. Buy and install the second disk.
   Make sure you partition it to the desired sizes, and set all
   partitions to type 'fd', 'RAID autodiscovery'.

2. Use mdadm to create the RAID1 in "degraded" mode, using only the
   second disk.  eg:

   ] mdadm --create --level=1 --raid-devices=2 --spare-devices=0 \
         /dev/md1 missing /dev/hdc1

   Season that invocation to taste, WRT the number of RAID and spare
   devices.  The 'missing' statement takes the place of the current
   single drive.

3. Make your filesystem on the degraded RAID1.  eg:

   ] mke2fs -j /dev/md1

4. Create some useful mountpoints:

   ] mkdir /mnt/from /mnt/to

5. Reboot to "running bugger all" mode;  add 'init=/bin/sh' to your
   kernel command line.

6. Mount your root and the MD device:

   ] mount /dev/hda1 /mnt/from -o ro
   ] mount /dev/md1  /mnt/to   -o rw

7. Transfer the data across:

   ] (cd /mnt/from; tar clp .) | (cd /mnt/to; tar xp)

8. Edit /mnt/to/etc/fstab, and /mnt/to/etc/lilo.conf if needed, to
   reflect the new 'root on /dev/md1' state.  Run lilo if needed...

9. Unmount:

   ] umount /mnt/from
   ] umount /mnt/to

10. Sync carefully, since you will be doing an unclean reboot after this:

   ] sync; sync; sync; sleep 30; sync

11. Power-cycle the machine.

12. Log in, with root now on /dev/md1, and check that it all worked.

13. Once you are happy, add the old drive to the array.  This is the
    point at which you can no longer back out, so be *sure* you are
    ready to do it...

    ] mdadm /dev/md1 -a /dev/hda1

14. Watch /proc/mdstat to see when your resync is complete.

15. Check that all your partitions are type 'fd', for auto-discovery to
    work.  Probably you need to change the previous root disk.


For anything that isn't your root partition, you can omit the boot with
'init=/bin/bash' stage, and just unmount the source partition in single
user mode.

     Daniel

-- 
The greatest humiliation in life, is to work hard on something from which you
expect great appreciation, and then fail to get it.
        -- Edgar Watson Howe, _Ventures in Common Sense_, 1919

