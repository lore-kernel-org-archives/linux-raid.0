From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: mdadm: sending ioctl [1261|800c0910] to a partition!
Date: Mon, 11 Nov 2013 12:13:14 +0200
Message-ID: <FE57A73F-D70A-4D2C-A658-BB320A0ECA35@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everyone,

I was wondering what the following kernel messages mean in plain Englis=
h

sending ioctl 1261 to a partition!=20

and

mdadm: sending ioctl 800c0910 to a partition!

Oh, and this as well

scsi_verify_blk_ioctl: 52 callbacks suppressed

What would it tell me, if I read this technical language? The exclamati=
on mark is a bit alarming, and as for suppressed callbacks I have no id=
ea whether it is something I should be paying attention to or not.

Could anyone, please, comment on this?

Ivan

> Nov 11 09:22:36 localhost mtp-probe: bus: 1, device: 82 was not an MT=
P device
> Nov 11 09:22:36 localhost mtp-probe: bus: 1, device: 84 was not an MT=
P device
> Nov 11 09:22:36 localhost kernel: [915118.933393] sd 64:0:0:0: [sdb] =
Spinning up disk...
> Nov 11 09:22:36 localhost kernel: [915119.162577] scsi 65:0:0:0: Dire=
ct-Access     WD       Elements 1048    1022 PQ: 0 ANSI: 6
> Nov 11 09:22:36 localhost kernel: [915119.166417] sd 65:0:0:0: [sdc] =
Spinning up disk=85
> Nov 11 09:22:38 localhost kernel: [915119.935212] ...ready
> Nov 11 09:22:38 localhost kernel: [915120.939446] sd 64:0:0:0: [sdb] =
3907024896 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Nov 11 09:22:38 localhost kernel: [915120.939456] sd 64:0:0:0: [sdb] =
4096-byte physical blocks
> Nov 11 09:22:38 localhost kernel: [915120.940296] sd 64:0:0:0: [sdb] =
Write Protect is off
> Nov 11 09:22:38 localhost kernel: [915120.940305] sd 64:0:0:0: [sdb] =
Mode Sense: 47 00 10 08
> Nov 11 09:22:38 localhost kernel: [915120.941055] sd 64:0:0:0: [sdb] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915120.941064] sd 64:0:0:0: [sdb] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915120.944179] sd 64:0:0:0: [sdb] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915120.944189] sd 64:0:0:0: [sdb] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915120.955938]  sdb: sdb1
> Nov 11 09:22:38 localhost kernel: [915120.961429] sd 64:0:0:0: [sdb] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915120.961439] sd 64:0:0:0: [sdb] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915120.961448] sd 64:0:0:0: [sdb] =
Attached SCSI disk
> Nov 11 09:22:38 localhost kernel: [915121.171868] .ready
> Nov 11 09:22:38 localhost kernel: [915121.172593] sd 65:0:0:0: [sdc] =
3907024896 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Nov 11 09:22:38 localhost kernel: [915121.172603] sd 65:0:0:0: [sdc] =
4096-byte physical blocks
> Nov 11 09:22:38 localhost kernel: [915121.173457] sd 65:0:0:0: [sdc] =
Write Protect is off
> Nov 11 09:22:38 localhost kernel: [915121.173466] sd 65:0:0:0: [sdc] =
Mode Sense: 47 00 10 08
> Nov 11 09:22:38 localhost kernel: [915121.174206] sd 65:0:0:0: [sdc] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915121.174215] sd 65:0:0:0: [sdc] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915121.176712] sd 65:0:0:0: [sdc] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915121.176721] sd 65:0:0:0: [sdc] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915121.203618]  sdc: sdc1
> Nov 11 09:22:38 localhost kernel: [915121.206581] sd 65:0:0:0: [sdc] =
No Caching mode page present
> Nov 11 09:22:38 localhost kernel: [915121.206592] sd 65:0:0:0: [sdc] =
Assuming drive cache: write through
> Nov 11 09:22:38 localhost kernel: [915121.206600] sd 65:0:0:0: [sdc] =
Attached SCSI disk
> Nov 11 09:22:38 localhost kernel: [915121.275271] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.275282] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.275503] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.275510] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.276125] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.276134] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.276737] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.276744] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.277360] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.277367] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:38 localhost kernel: [915121.314932] md: bind<sdb1>
> Nov 11 09:22:38 localhost kernel: [915121.429234] md: bind<sdc1>
> Nov 11 09:22:39 localhost kernel: [915121.727465] md/raid1:md0: activ=
e with 2 out of 2 mirrors
> Nov 11 09:22:39 localhost kernel: [915121.729320] created bitmap (15 =
pages) for device md0
> Nov 11 09:22:39 localhost kernel: [915121.732854] md0: bitmap initial=
ized from disk: read 1/1 pages, set 0 of 29805 bits
> Nov 11 09:22:39 localhost kernel: [915121.733569] md0: detected capac=
ity change from 0 to 2000155377664
> Nov 11 09:22:39 localhost kernel: [915121.741062]  md0: unknown parti=
tion table
> Nov 11 09:22:44 localhost kernel: [915126.520641] scsi_verify_blk_ioc=
tl: 52 callbacks suppressed
> Nov 11 09:22:44 localhost kernel: [915126.520647] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.520651] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.520658] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.520661] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.580307] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.580317] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.580328] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.580334] mdadm: sending ioct=
l 1261 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.632584] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:44 localhost kernel: [915126.632593] mdadm: sending ioct=
l 800c0910 to a partition!
> Nov 11 09:22:48 localhost kernel: [915130.736792] EXT4-fs (md0): moun=
ted filesystem with ordered data mode. Opts: (null)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
