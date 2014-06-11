From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: raid5.c::grow_stripes() kmem_cache_create() race
Date: Wed, 11 Jun 2014 19:00:42 +0300
Message-ID: <CAGRgLy5Nz7aVRsqhco1eUB0hTvnYgupaUuGv=wA7ttWg+mdBmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Yair Hershko <yair@zadarastorage.com>, Vladimir Popovski <vladimir@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>
List-Id: linux-raid.ids

Hi Neil,
in your master branch, you have a code like:

static int grow_stripes(struct r5conf *conf, int num)
{
    struct kmem_cache *sc;
    int devs = max(conf->raid_disks, conf->previous_raid_disks);
    int hash;

    if (conf->mddev->gendisk)
        sprintf(conf->cache_name[0],
            "raid%d-%s", conf->level, mdname(conf->mddev));
    else
        sprintf(conf->cache_name[0],
            "raid%d-%p", conf->level, conf->mddev);
    sprintf(conf->cache_name[1], "%s-alt", conf->cache_name[0]);

    conf->active_name = 0;
    sc = kmem_cache_create(conf->cache_name[conf->active_name],
                   sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
                   0, 0, NULL);

In our case what happened was:
- we were assembling two MDs in parallel: md4 and md5
- each one tried to create its own kmem_cache: raid5-md4 and raid5-md5
(each one had valid conf->mmdev->gendisk)

In our kernel SLUB is configured. So the code went to
slub.c::__kmem_cache_create(). It called sysfs_slab_add(), which
eventually tried to do:

if (unmergeable) {
    // not here
} else {
    // we went here
    name = create_unique_id(s);
}

For both threads calling this, it created the same unique id:
"t-0001832". And then sysfs freaked out and complained[1]. So md5 was
unlucky and failed to initialize, and md4 got lucky and came up.
Later, we retried md5 assembly and it worked alright.

In this case, both MDs have the same number of disks. That's why
kernel tried to have a single cache. Problem is that
__kmem_cache_create unlocks slab_mutex, so that's why the race becomes
possible.

I realize that this is not MD-specific, but rather slab-specific
issue, but do you have any idea how to fix that?:(

Thanks,
Alex.

 kernel: [  151.328479] ------------[ cut here ]------------
 kernel: [  151.328485] WARNING: at
/home/apw/COD/linux/fs/sysfs/dir.c:536 sysfs_add_one+0xc8/0x100()
 kernel: [  151.328486] Hardware name: Bochs
 kernel: [  151.328487] sysfs: cannot create duplicate filename
'/kernel/slab/:t-0001832'
 kernel: [  151.328488] Modules linked in: raid456(OF) async_pq
async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx
raid1(OF) xt_multiport dm_queue_length 8021q garp stp llc bonding
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
iptable_filter ip_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_core ib_addr iscsi_tcp(OF) libiscsi_tcp(OF) libiscsi(OF)
scsi_transport_iscsi(OF) ixgbevf(OF) xfrm_user xfrm4_tunnel tunnel4
ipcomp xfrm_ipcomp esp4 ah4 dm_zcache(OF) dm_btrfs(OF) xfs(OF)
btrfs(OF) dm_iostat(OF) scst_vdisk(OF) iscsi_scst(OF) scst(OF)
libcrc32c deflate zlib_deflate ctr twofish_generic twofish_x86_64_3way
twofish_x86_64 twofish_common camellia_generic camellia_x86_64
nls_iso8859_1 serpent_sse2_x86_64 glue_helper lrw serpent_generic xts
gf128mul blowfish_generic blowfish_x86_64 blowfish_common ablk_helper
cryptd cast5_generic cast_common des_generic xcbc rmd160 nfsd(OF)
nfs_acl auth_rpcgss nfs fscache lockd sunrpc crypto_null af_key
xfrm_algo kvm
 kernel: dm_multipath(OF) microcode scsi_dh psmouse serio_raw
virtio_balloon cirrus ttm drm_kms_helper mac_hid drm sysimgblt
sysfillrect syscopyarea i2c_piix4 lp parport floppy [last unloaded:
ixgbevf]
 kernel: [  151.328549] Pid: 7714, comm: mdadm Tainted: GF          O
3.8.13-030813-generic #201305111843
 kernel: [  151.328550] Call Trace:
 kernel: [  151.328556]  [<ffffffff8105990f>] warn_slowpath_common+0x7f/0xc0
 kernel: [  151.328559]  [<ffffffff81059a06>] warn_slowpath_fmt+0x46/0x50
 kernel: [  151.328564]  [<ffffffff813588a0>] ? strlcat+0x60/0x80
 kernel: [  151.328566]  [<ffffffff81210a38>] sysfs_add_one+0xc8/0x100
 kernel: [  151.328568]  [<ffffffff81210c2c>] create_dir+0x7c/0xd0
 kernel: [  151.328570]  [<ffffffff81210fa6>] sysfs_create_dir+0x86/0xd0
 kernel: [  151.328573]  [<ffffffff8135282c>] kobject_add_internal+0x9c/0x210
 kernel: [  151.328575]  [<ffffffff81352d93>] kobject_init_and_add+0x63/0x90
 kernel: [  151.328579]  [<ffffffff81185ab2>] sysfs_slab_add+0x82/0x130
 kernel: [  151.328582]  [<ffffffff811877b4>] __kmem_cache_create+0x54/0x1b0
 kernel: [  151.328585]  [<ffffffff81157036>]
kmem_cache_create_memcg+0x126/0x230
 kernel: [  151.328587]  [<ffffffff8115716b>] kmem_cache_create+0x2b/0x30
 kernel: [  151.328592]  [<ffffffffa081ce38>] setup_conf+0x6b8/0x8c0 [raid456]
 kernel: [  151.328595]  [<ffffffffa081dc0f>] run+0x88f/0xad0 [raid456]
 kernel: [  151.328599]  [<ffffffff8156c86b>] md_run+0x26b/0x780
 kernel: [  151.328603]  [<ffffffff813121b0>] ? apparmor_capable+0x20/0x90
 kernel: [  151.328605]  [<ffffffff8156cd9d>] do_md_run+0x1d/0xc0
 kernel: [  151.328608]  [<ffffffff8156e05d>] md_ioctl+0x6fd/0x860
 kernel: [  151.328612]  [<ffffffff8119acb3>] ? do_sync_write+0xa3/0xe0
 kernel: [  151.328615]  [<ffffffff81335f8e>] blkdev_ioctl+0xde/0x830
 kernel: [  151.328619]  [<ffffffff811d3660>] block_ioctl+0x40/0x50
 kernel: [  151.328621]  [<ffffffff811acfea>] do_vfs_ioctl+0x8a/0x340
 kernel: [  151.328623]  [<ffffffff811ad331>] sys_ioctl+0x91/0xb0
 kernel: [  151.328626]  [<ffffffff8119b692>] ? sys_write+0x52/0xa0
 kernel: [  151.328630]  [<ffffffff816f629d>] system_call_fastpath+0x1a/0x1f
 kernel: [  151.328632] ---[ end trace ec5fba74187fec78 ]---
 kernel: [  151.328633] ------------[ cut here ]------------
 kernel: [  151.328636] WARNING: at
/home/apw/COD/linux/lib/kobject.c:196
kobject_add_internal+0x1f4/0x210()
 kernel: [  151.328637] Hardware name: Bochs
 kernel: [  151.328638] kobject_add_internal failed for :t-0001832
with -EEXIST, don't try to register things with the same name in the
same directory.
 kernel: [  151.328639] Modules linked in: raid456(OF) async_pq
async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx
raid1(OF) xt_multiport dm_queue_length 8021q garp stp llc bonding
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
iptable_filter ip_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_core ib_addr iscsi_tcp(OF) libiscsi_tcp(OF) libiscsi(OF)
scsi_transport_iscsi(OF) ixgbevf(OF) xfrm_user xfrm4_tunnel tunnel4
ipcomp xfrm_ipcomp esp4 ah4 dm_zcache(OF) dm_btrfs(OF) xfs(OF)
btrfs(OF) dm_iostat(OF) scst_vdisk(OF) iscsi_scst(OF) scst(OF)
libcrc32c deflate zlib_deflate ctr twofish_generic twofish_x86_64_3way
twofish_x86_64 twofish_common camellia_generic camellia_x86_64
nls_iso8859_1 serpent_sse2_x86_64 glue_helper lrw serpent_generic xts
gf128mul blowfish_generic blowfish_x86_64 blowfish_common ablk_helper
cryptd cast5_generic cast_common des_generic xcbc rmd160 nfsd(OF)
nfs_acl auth_rpcgss nfs fscache lockd sunrpc crypto_null af_key
xfrm_algo kvm
 kernel: dm_multipath(OF) microcode scsi_dh psmouse serio_raw
virtio_balloon cirrus ttm drm_kms_helper mac_hid drm sysimgblt
sysfillrect syscopyarea i2c_piix4 lp parport floppy [last unloaded:
ixgbevf]
 kernel: [  151.328682] Pid: 7714, comm: mdadm Tainted: GF       W  O
3.8.13-030813-generic #201305111843
 kernel: [  151.328683] Call Trace:
 kernel: [  151.328685]  [<ffffffff8105990f>] warn_slowpath_common+0x7f/0xc0
 kernel: [  151.328687]  [<ffffffff81059a06>] warn_slowpath_fmt+0x46/0x50
 kernel: [  151.328690]  [<ffffffff81352984>] kobject_add_internal+0x1f4/0x210
 kernel: [  151.328692]  [<ffffffff81352d93>] kobject_init_and_add+0x63/0x90
 kernel: [  151.328694]  [<ffffffff81185ab2>] sysfs_slab_add+0x82/0x130
 kernel: [  151.328697]  [<ffffffff811877b4>] __kmem_cache_create+0x54/0x1b0
 kernel: [  151.328699]  [<ffffffff81157036>]
kmem_cache_create_memcg+0x126/0x230
 kernel: [  151.328701]  [<ffffffff8115716b>] kmem_cache_create+0x2b/0x30
 kernel: [  151.328704]  [<ffffffffa081ce38>] setup_conf+0x6b8/0x8c0 [raid456]
 kernel: [  151.328707]  [<ffffffffa081dc0f>] run+0x88f/0xad0 [raid456]
 kernel: [  151.328709]  [<ffffffff8156c86b>] md_run+0x26b/0x780
 kernel: [  151.328711]  [<ffffffff813121b0>] ? apparmor_capable+0x20/0x90
 kernel: [  151.328713]  [<ffffffff8156cd9d>] do_md_run+0x1d/0xc0
 kernel: [  151.328715]  [<ffffffff8156e05d>] md_ioctl+0x6fd/0x860
 kernel: [  151.328718]  [<ffffffff8119acb3>] ? do_sync_write+0xa3/0xe0
 kernel: [  151.328720]  [<ffffffff81335f8e>] blkdev_ioctl+0xde/0x830
 kernel: [  151.328722]  [<ffffffff811d3660>] block_ioctl+0x40/0x50
 kernel: [  151.328724]  [<ffffffff811acfea>] do_vfs_ioctl+0x8a/0x340
 kernel: [  151.328726]  [<ffffffff811ad331>] sys_ioctl+0x91/0xb0
 kernel: [  151.328728]  [<ffffffff8119b692>] ? sys_write+0x52/0xa0
 kernel: [  151.328731]  [<ffffffff816f629d>] system_call_fastpath+0x1a/0x1f
 kernel: [  151.328732] ---[ end trace ec5fba74187fec79 ]---
 kernel: [  151.328745] kmem_cache_create(raid5-md5) failed with error
-17Pid: 7714, comm: mdadm Tainted: GF       W  O 3.8.13-030813-generic
#201305111843
 kernel: [  151.328747] Call Trace:
 kernel: [  151.328749]  [<ffffffff811570ef>]
kmem_cache_create_memcg+0x1df/0x230
 kernel: [  151.328751]  [<ffffffff8115716b>] kmem_cache_create+0x2b/0x30
 kernel: [  151.328754]  [<ffffffffa081ce38>] setup_conf+0x6b8/0x8c0 [raid456]
 kernel: [  151.328757]  [<ffffffffa081dc0f>] run+0x88f/0xad0 [raid456]
 kernel: [  151.328759]  [<ffffffff8156c86b>] md_run+0x26b/0x780
 kernel: [  151.328761]  [<ffffffff813121b0>] ? apparmor_capable+0x20/0x90
 kernel: [  151.328764]  [<ffffffff8156cd9d>] do_md_run+0x1d/0xc0
 kernel: [  151.328766]  [<ffffffff8156e05d>] md_ioctl+0x6fd/0x860
 kernel: [  151.328768]  [<ffffffff8119acb3>] ? do_sync_write+0xa3/0xe0
 kernel: [  151.328771]  [<ffffffff81335f8e>] blkdev_ioctl+0xde/0x830
 kernel: [  151.328773]  [<ffffffff811d3660>] block_ioctl+0x40/0x50
 kernel: [  151.328774]  [<ffffffff811acfea>] do_vfs_ioctl+0x8a/0x340
 kernel: [  151.328776]  [<ffffffff811ad331>] sys_ioctl+0x91/0xb0
 kernel: [  151.328779]  [<ffffffff8119b692>] ? sys_write+0x52/0xa0
 kernel: [  151.328781]  [<ffffffff816f629d>] system_call_fastpath+0x1a/0x1f
 kernel: [  151.328783] md/raid:md5: couldn't allocate 5394kB for buffers
 kernel: [  151.329532] md: pers->run() failed ...
 kernel: [  151.331026] md/raid:md4: allocated 5394kB
