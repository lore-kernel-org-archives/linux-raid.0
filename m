From: "Kenneth D. Merry" <ken@kdm.org>
Subject: new md patches available, including Adaptec metadata support
Date: Thu, 12 Sep 2002 14:45:58 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020912144558.A63567@panzer.kdm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


I'm pleased to announce the availability of a new set of md patches that
fix some bugs, and implement some new features.

The patchset is against 2.4.18, and is available here:

http://people.freebsd.org/~ken/linux/md.html

This work is sponsored by Adaptec (www.adaptec.com).

Basic summary of changes and features:

1.  Adaptec metadata support.  The type of Adaptec metadata supported
    here is used on controllers supported by the dpt_i2o driver (e.g.
    2100, 3200, 3400, 3210, 3410, etc. RAID cards).  (Note that cards
    supported by the aacraid driver, like the 5400 and the 2200,
    which has been recently announced, use a different type of metadata.)

    This metadata will also be used on some upcoming Adaptec products.

    This metadata support only works for RAID 0 and 1.  RAID 5 support
    would be possible in theory, but I haven't done the work to get
    RAID 5 functional.

2.  Somewhat abstracted metadata support.  Although the in-core
    metadata code hasn't changed much, it can now get translated to 
    Adaptec metadata on the "bottom end" of things.

3.  Verify and verify-and-fix functionality.  A verify or a
    verify-and-fix can be kicked off via something like mdadm.  I've
    put patches for mdctl-0.4.2 here:

    http://people.freebsd.org/~ken/linux/mdctl_adaptec.diffs.20010920

    But they could be ported to a newer version of mdadm without much
    trouble.

4.  Checkpointing.  With Adaptec metadata, md can checkpoint the
    operation currently outstanding on the array (verify, resync,
    etc.) and the point the operation has reached.  So if you reboot
    your machine during a verify, it'll pick back up where it left
    off.

5.  Improved error recovery.

6.  Parellel reconstruction and resync.  With these patches, each md
    array can reconstruct or resync independently of the others,
    instead of being gated on a single kernel thread.

7.  Targeted resync.  The md RAID-1 code can now resync from the
    second disk onto the first disk, if that is necessary.  Currently
    md can only resync from the primary disk onto the secondary.

8.  RAID 0 I/O requests can span multiple drives or exceed the stripe
    size.  They no longer have to be contained to a single disk.

9.  Partitionable arrays.  This patchset includes Neil Brown's
    partitionable md patches.  The partitionable devices are /dev/mda,
    /dev/mdb, etc., and use the standard Linux partitionable device
    naming scheme.  (e.g. the first partition on mda is /dev/mda1)

10. Improved autodetection.  md can now autodetect Adaptec metadata or
    md metadata arrays that are composed either of whole disks or
    individual partitions.  So you don't necessarily have to have
    Linux RAID partitions in order for your array to be autodetected.

11. A new task queueing system for md.  You can now queue tasks for
    the main thread in each md instance to execute.  (e.g. resync,
    verify, etc.)

12. A new disk/device arrival notification system for Linux.  This
    code allows kernel clients to be notified when a new disk, or
    partition with a particular type, arrives.  I wrote this code
    to provide an infrastructure that md could use so that the core md
    code could be loaded as a module and still see disks that arrived
    in the system before md is loaded.

    Currently, md has to be statically compiled into the kernel in
    order for autodetection to work.  It has to be able to "see" disks
    (via md_autodetect_dev()) as they come into the system.

    With the new 'diskpart' code, when md registers its notification
    routine, it'll be informed of any disks that have arrived up to
    that point, and any disks that arrive in the future.

    Although this would allow loading the core md code as a module, it
    still won't really do anything for the case where disks arrive
    after md has run its autoconfiguration hook (md_run_setup()),
    since md would need to support the incremental arrival of disks.
    It currently assumes, during autoconfiguration, that all the
    necessary disks in the array are either there or not there.  (it
    doesn't take into account disks that have yet to arrive, except to
    assume they aren't there)

Note that you can't really create or manage an Adaptec metadata array
from userland.  You basically have to create the array using a RAID
controller, and then you can detect it and use it with md.

Ken
-- 
Kenneth Merry
ken@kdm.org
