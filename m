From: NeilBrown <neil@brown.name>
Subject: Re: cluster-md mddev->in_sync & mddev->safemode_delay may have bug
Date: Thu, 16 Jul 2020 10:54:58 +1000
Message-ID: <87zh80wa71.fsf@notabene.neil.brown.name>
References: <a29f8374-cc64-cc87-71cb-507c43aff503@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a29f8374-cc64-cc87-71cb-507c43aff503@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jul 15 2020, heming.zhao@suse.com wrote:

> Hello List,
>
>
> @Neil  @Guoqing,
> Would you have time to take a look at this bug?
>
> This mail replaces previous mail: commit 480523feae581 may introduce a bug.
> Previous mail has some unclear description, I sort out & resend in this mail.
>
> This bug was reported from a SUSE customer.

I think my answer would be that this is not a bug.

The "active" state is effectively a 1-bit bitmap of active regions of
the array.   When there is no full bitmap, this can be useful.
When this is a bit map, it is of limited use.  It is just a summary of
the bitmap.  i.e. if all bits in the bitmap are clear, then the 'active'
state can be clear.  If any bit is set, then the 'active' state must be
set.

With a clustered array, there are multiple bitmaps which can be changed
asynchronously by other nodes.  So reporting that the array not "active"
is either unreliable or expensive.

Probably the best "fix" would be to change mdadm to not report the
"active" flag if there is a bitmap.  Instead, examine the bitmaps
directly and see if any bits are set.

So if MD_SB_CLEAN is set, report "clean".
If not, examine all bitmaps and if they are all clean, report "clean"
else report active (and optionally report % of bits set).

I would recommend against the kernel code change that you suggest.

For the safemode issue when converting to clustered bitmap, it would
make sense for md_setup_cluster() to set ->safemode_delay to zero
on success.  Similarly md_cluster_stop() could set it to the default
value.

NeilBrown


>
> In cluster-md env, after below steps, "mdadm -D /dev/md0" shows "State: active" all the time.
> ```
> # mdadm -S --scan
> # mdadm --zero-superblock /dev/sd{a,b}
> # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>
> # mdadm -D /dev/md0
> /dev/md0:
>             Version : 1.2
>       Creation Time : Mon Jul  6 12:02:23 2020
>          Raid Level : raid1
>          Array Size : 64512 (63.00 MiB 66.06 MB)
>       Used Dev Size : 64512 (63.00 MiB 66.06 MB)
>        Raid Devices : 2
>       Total Devices : 2
>         Persistence : Superblock is persistent
>
>       Intent Bitmap : Internal
>
>         Update Time : Mon Jul  6 12:02:24 2020
>               State : active <==== this line
>      Active Devices : 2
>     Working Devices : 2
>      Failed Devices : 0
>       Spare Devices : 0
>
> Consistency Policy : bitmap
>
>                Name : lp-clustermd1:0  (local to host lp-clustermd1)
>        Cluster Name : hacluster
>                UUID : 38ae5052:560c7d36:bb221e15:7437f460
>              Events : 18
>
>      Number   Major   Minor   RaidDevice State
>         0       8        0        0      active sync   /dev/sda
>         1       8       16        1      active sync   /dev/sdb
> ```
>
> with commit 480523feae581 (author: Neil Brown), the try_set_sync never true, so mddev->in_sync always 0.
>
> the simplest fix is bypass try_set_sync when array is clustered.
> ```
>   void md_check_recovery(struct mddev *mddev)
>   {
>      ... ...
>          if (mddev_is_clustered(mddev)) {
>              struct md_rdev *rdev;
>              /* kick the device if another node issued a
>               * remove disk.
>               */
>              rdev_for_each(rdev, mddev) {
>                  if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
>                          rdev->raid_disk < 0)
>                      md_kick_rdev_from_array(rdev);
>              }
> +           try_set_sync = 1;
>          }
>      ... ...
>   }
> ```
> this fix makes commit 480523feae581 doesn't work when clustered env.
> I want to know what impact with above fix.
> Or does there have other solution for this issue?
>
>
> --------
> And for mddev->safemode_delay issue
>
> There is also another bug when array change bitmap from internal to clustered.
> the /sys/block/mdX/md/safe_mode_delay keep original value after changing bitmap type.
> in safe_delay_store(), the code forbids setting mddev->safemode_delay when array is clustered.
> So in cluster-md env, the expected safemode_delay value should be 0.
>
> reproduction steps:
> ```
> # mdadm --zero-superblock /dev/sd{b,c,d}
> # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
> # cat /sys/block/md0/md/safe_mode_delay
> 0.204
> # mdadm -G /dev/md0 -b none
> # mdadm --grow /dev/md0 --bitmap=clustered
> # cat /sys/block/md0/md/safe_mode_delay
> 0.204  <== doesn't change, should ZERO for cluster-md
> ```
>
> thanks

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8PpWIACgkQOeye3VZi
gbl0SA//dFIl6fQFdS5Of7ysELbRUHKrkAEE2GtvDMRJW+zYh0V1CF+UmnWePrZe
lqXLLLteOkmADX8dus7Ti6V++XlNgcs34wKnzszQdRBjeMZsHcZuNSMDYd7+XeAM
8Wsu6H99qd7YXboRIhyVo6hnsok5r/JzdHdSN+Zh+ropv/jZTDZ3YJXd2XfKP5Ny
Q5lFn+2btOQf26DUbQati4Ft2YSeghVQvcPQUEnRfzHLde4pkAn6phO88jDFSu5z
zrCPWGWzSNE4UPrm9EyK1xz1HLo8RnQ0SjrOTubEh39RZcEkapskYn8st91Db/5z
hCnZcIBvY0/+NgsKIGc34XkeoTjKCR4EXfao23wOMLUxZXtIF6BVsIUJBgSDMFrT
ZM+oDY6KNFIGUqBVKnqmoJtzMDc93Y5eFRaXdZ965ZzheVAOqYvQGk+zu4IVxWhW
GVbqSOdIROx1vSM+91tE1KWK/pF2dwZ5UF0iBSfKTuMMbocI6JftEgFCNqfeSaCx
gveI29wISsoAxqSnYMvhEkz82TZOLlCEAhyU8x1/UmvOmsVpkk6FNcRKZ3/RcQr1
2Tufe8GNj5ZkoBKuJ2V7pAC3pszVx4Z8UBswwWf9WMK4ynw1XmWyCvqx1+yvI8hh
pkbMMiN1fWij85nK/xRrhDP5eItBs23VDSFOAlDND78CRILAxJU=
=dwC4
-----END PGP SIGNATURE-----
--=-=-=--
