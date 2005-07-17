From: djani22@dynamicweb.hu
Subject: Found a new bug!
Date: Sun, 17 Jul 2005 14:10:26 +0200
Message-ID: <009001c58ac8$9ab25d40$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene> <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

I think I found a new bug in the kernel ! (or mdadm?)

First I try this:
mkraid --configfile /etc/raidtab.nw /dev/md0 -R
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
couldn't get device size for /dev/md31 -- File too large
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as well
 for potential clues.)

Next  I try this:

./create_linear
mdadm: /dev/md31 appears to be part of a raid array:
    level=0 devices=1 ctime=Sun Jul 17 13:30:27 2005
Continue creating array? y
./create_linear: line 1:  2853 Segmentation fault      mdadm --create
/dev/md0 --chunk=32 --level=linear --force --raid-devices=1 /dev/md31

After this little script the half of the raid subsystem hangs:

The raidtools makes nothing, the mdadm makes nothing too.
AND the cat /proc/mdstat is hangs too!
But the /dev/md31 device is still working.

mdstat in previous 2s: (watch cat /proc/mdstat)

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [faulty]
md31 : active raid0 md4[3] md3[2] md2[1] md1[0]
      7814332928 blocks 32k chunks

md4 : active raid1 nbd3[0]
      1953583296 blocks [2/1] [U_]

md3 : active raid1 nbd2[0]
      1953583296 blocks [2/1] [U_]

md2 : active raid1 nbd1[0]
      1953583296 blocks [2/1] [U_]

md1 : active raid1 nbd0[0]
      1953583296 blocks [2/1] [U_]

unused devices: <none>

Kernel: 2.6.13-rc3
raidtools-1.00.3
mdadm-1.12.0

The background:
I try to build a big array ~8TB.

I use for this 5 PCs.
4 for "disk nodes" with nbd and 1 for "concentrator".
(from previous idea in this list. ;)
In the concentrator, the first level raid  (md1-4) is for ability to backup,
swap the disk nodes. (node-spare)
The next level (md31) is for the performance. ;)
And, the last level (md0 linear) for scalability.

Why dont use LVM for last level?
Well, I try that, but cat /dev/.../LV >/dev/null can do only 15 - 16 MB/s
and cat /dev/md31 >/dev/null can do 34-38MB/s.
(the network is G-Ethernet, but only 32bit/33MHz PCI!)

Thanks
Janos


----- Original Message -----
From: "NeilBrown" <neilb@cse.unsw.edu.au>
To: "Andrew Morton" <akpm@osdl.org>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, July 17, 2005 10:27 AM
Subject: [PATCH md ] When resizing an array, we need to update
resync_max_sectors as well as size.


> Another md patch against 2.6.13-rc2-mm2, suitable for 2.6.13.
> Thanks,
> NeilBrown
>
> ### Comments for Changeset
>
> Without this, and attempt to 'grow' an array will claim to have synced
> the extra part without actually having done anything.
>
> Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
>
> ### Diffstat output
>  ./drivers/md/raid1.c     |    1 +
>  ./drivers/md/raid5.c     |    1 +
>  ./drivers/md/raid6main.c |    1 +
>  3 files changed, 3 insertions(+)
>
> diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
> --- ./drivers/md/raid1.c~current~ 2005-07-17 18:25:47.000000000 +1000
> +++ ./drivers/md/raid1.c 2005-07-17 17:18:13.000000000 +1000
> @@ -1467,6 +1467,7 @@ static int raid1_resize(mddev_t *mddev,
>   set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   }
>   mddev->size = mddev->array_size;
> + mddev->resync_max_sectors = sectors;
>   return 0;
>  }
>
>
> diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
> --- ./drivers/md/raid5.c~current~ 2005-07-17 18:25:47.000000000 +1000
> +++ ./drivers/md/raid5.c 2005-07-17 18:25:52.000000000 +1000
> @@ -1931,6 +1931,7 @@ static int raid5_resize(mddev_t *mddev,
>   set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   }
>   mddev->size = sectors /2;
> + mddev->resync_max_sectors = sectors;
>   return 0;
>  }
>
>
> diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
> --- ./drivers/md/raid6main.c~current~ 2005-07-17 18:25:47.000000000 +1000
> +++ ./drivers/md/raid6main.c 2005-07-17 17:19:04.000000000 +1000
> @@ -2095,6 +2095,7 @@ static int raid6_resize(mddev_t *mddev,
>   set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   }
>   mddev->size = sectors /2;
> + mddev->resync_max_sectors = sectors;
>   return 0;
>  }
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

