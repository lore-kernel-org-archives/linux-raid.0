From: Marco Scoffier <marco@metm.org>
Subject: old raid0run
Date: Sun, 11 Feb 2007 01:33:06 -0500
Message-ID: <pan.2007.02.11.06.33.05.974944@metm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I have an old raid0 with no superblocks.

I have just upgraded the machine with this raid and mdadm is incapable of
mounting it.  Unfortunately raidtools will no longer compile*.  So I am a
bit stuck as I would like to save the data on this raid0.

Can I create a new raid0 using mdadm ?

  mdadm -C -n 2 -c 128 -l 0 /dev/md0 /dev/hde1 /dev/hdg1

or should I build a new raid0 and then upgrade that to a raid0 with
superblocks (how would I do that?)

Thanks for any pointers,



As there are no super-blocks mdadm is
giving very little information:

mdadm -E /dev/hde1
mdadm: No md superblock detected on /dev/hde1.
mdadm -E /dev/hdg1
mdadm: No md superblock detected on /dev/hdg1.

mdadm -As /dev/md0 
mdadm: /dev/hde1 has no superblock - assembly aborted


the raidtab is clear:

# Sample raid-0 configuration

raiddev                 /dev/md0

raid-level              0    # it's not obvious but this *must* be 
                             # right after raiddev

persistent-superblock   0    # set this to 1 if you want autostart,
                             # BUT SETTING TO 1 WILL DESTROY PREVIOUS
                             # CONTENTS if this is a RAID0 array created
                             # by older raidtools (0.40-0.51) or mdtools!

chunk-size              128

nr-raid-disks           2
nr-spare-disks          0

device                  /dev/hde1
raid-disk               0

device                  /dev/hdg1
raid-disk               1

-- 
Marco

* the raidtools compile error is some awfull stuff in a macro.  There is a
bug report here: http://bugs.gentoo.org/show_bug.cgi?id=165917

