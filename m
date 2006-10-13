From: Eli Stair <estair@ilm.com>
Subject: Re: BUGS: internal bitmap during array create
Date: Thu, 12 Oct 2006 18:02:17 -0700
Message-ID: <452EE599.8030200@ilm.com>
References: <452D500D.6000203@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <452D500D.6000203@ilm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


As of NeilB's release a few minutes ago, this issue is still occuring. 
Looks like the XFS superblock isn't being written properly or is 
corrupted upon read:

/// xfs_repair can't validate superblock:

     [root@gtmp04 ~]# xfs_repair /dev/md0
     Phase 1 - find and verify superblock...
     bad primary superblock - bad magic number !!!
     attempting to find secondary superblock...



/// xfs_check doesn't like superblock magic:

     [root@gtmp04 ~]# xfs_check -v /dev/md0
     xfs_check: unexpected XFS SB magic number 0x00000000
     xfs_check: read failed: Invalid argument
     xfs_check: data size check failed


Thanks!

/eli


Eli Stair wrote:
> 
> After realizing my stupid error in specifying the bitmap during array
> creation, I've triggered a couple of 100% repeatable bugs with this
> scenario.
> 
> 
> BUG 1)
> 
> When I create an array without a bitmap and add it after the array is
> synced, all works fine with any filesystem.  If I create WITH the
> internal bitmap and use xfs, it chokes at mount time with:
> 
>      mount: wrong fs type, bad option, bad superblock on /dev/md0,
>      or too many mounted file systems
> 
> xfs_check also dies with:
> 
>      [root@gtmp01 GTMP]# xfs_check /dev/md0
>      xfs_check: unexpected XFS SB magic number 0x00000000
>      xfs_check: read failed: Invalid argument
>      xfs_check: data size check failed
>      /usr/sbin/xfs_check: line 28: 30580 Segmentation fault
> xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
> 
> 
> Strangely, whatever the underlying cause is, ext3 seems immune (at least
> in brief testing) to this.  I can create and mount an ext3 filesystem on
> top of the array that xfs dies trying to mount.
> 
> In the case where the array is created with bitmap at build time, if I
> wait until resync is completed, do a 'mdadm -Gb none' followed by 'mdadm
> -Gb internal', I can then safely create the XFS filesystem and mount it.
> 
> BUG 2)
> 
> Another bitmap failure during create time:  MDADM dies with an error
> after creating the array, when it tries to assemble it, with an
> external-file bitmap (on ext3):
> 
> 
>      [root@gtmp01 GTMP]# mdadm -C /dev/md0 -f --chunk=512 --level=10
> -n14 -po2 -e1.2 -bESC[1P^M[root@gtmp01 GTMP]# mdadm -C /dev/md0 -f
> --chunk=512 --level=10 -n14 -po2 -e1.2 -b/var/tmp/bitmap /dev/mapper/mpath*
>      mdadm: RUN_ARRAY failed: Cannot allocate memory
>      mdadm: stopped /dev/md0
> 
> 
> The array can be manually assembled, but it does not load with the
> bitmap, even when specifying it with 'mdadm -A /dev/md0 -b/var/tmp/bitmap'.
> 
> 
> 
> 
> For reference, I'm running:
> 
> mdadm - v2.5.3 -  7 August 2006
> mkfs.xfs version 2.8.11
> kernel 2.6.18 (Opteron, x86_64, SMP)
> 
> 
> I've attached typescript of the sessions where I run through all of
> these scenarios, as well as an strace of the "mdadm -C
> -b/var/tmp/bitmap" where it fails to assemble the array.  Also is a file
> with the superblock detail on all the member devices.
> 
> Again, more than happy to help test patches and any scenarios.
> 
> Cheers,
> 
> /eli
> 

