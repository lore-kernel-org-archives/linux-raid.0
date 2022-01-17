Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCDFC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jan 2022 20:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbiAQURP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 15:17:15 -0500
Received: from mail.fairlystable.org ([216.151.3.163]:53134 "EHLO
        mail.fairlystable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiAQURK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Jan 2022 15:17:10 -0500
X-Greylist: delayed 3119 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2022 15:17:10 EST
Received: from [97.120.101.12] (helo=localhost)
        by mail.fairlystable.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jrayhawk@fairlystable.org>)
        id 1n9Xcq-0004cx-5h; Mon, 17 Jan 2022 11:25:08 -0800
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="===============6814218357873234810=="
MIME-Version: 1.0
Content-Disposition: inline
From:   Joe Rayhawk <jrayhawk@fairlystable.org>
To:     linux-raid@vger.kernel.org
Subject: raid6: badblocks-related bio panics
Date:   Mon, 17 Jan 2022 11:24:32 -0800
Message-ID: <164244747275.86917.2623783912687807916@richardiv.omgwallhack.org>
User-Agent: alot/0.10
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--===============6814218357873234810==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

A raid6 array of mine produces one of the following results upon reading
a particular stripe:
commit c82aa1b76787c34fd02374e519b6f52cdeb2f54b^: I/O error
commit c82aa1b76787c34fd02374e519b6f52cdeb2f54b: panic
commit 1a7e76e4f130332b5d3b0c72c4f664e59deb1239^: panic
commit 1a7e76e4f130332b5d3b0c72c4f664e59deb1239: I/O error, then panic
  on second read

jrayhawk@yuzz:~/src/linux$ sudo ./linux break=3Dtop con=3Dtty:$(tty) mem=3D=
1G $(n=3D1; for i in $( ls /sys/class/block/md0/slaves/ ); do echo -n ubd$(=
(n++))r=3D/dev/${i}" "; done)
[...]
/ # mdadm --assemble --scan
mdadm: failed to get exclusive lock on mapfile
mdadm: failed to get exclusive lock on mapfile - continue anyway...
md: md0 stopped.
md/raid:md0: device ubdb operational as raid disk 0
md/raid:md0: device ubdm operational as raid disk 12
md/raid:md0: device ubdl operational as raid disk 11
md/raid:md0: device ubdn operational as raid disk 10
md/raid:md0: device ubdk operational as raid disk 9
md/raid:md0: device ubdj operational as raid disk 8
md/raid:md0: device ubdi operational as raid disk 7
md/raid:md0: device ubdg operational as raid disk 6
md/raid:md0: device ubdh operational as raid disk 5
md/raid:md0: device ubdf operational as raid disk 4
md/raid:md0: device ubde operational as raid disk 3
md/raid:md0: device ubdd operational as raid disk 2
md/raid:md0: device ubdc operational as raid disk 1
md/raid:md0: raid level 6 active with 13 out of 13 devices, algorithm 2
md0: detected capacity change from 0 to 32223655552
mdadm: /dev/md0 has been started with 13 drives.
/ # dd bs=3D$((1024*64*11)) skip=3D19477214 count=3D1 if=3D/dev/md0 of=3D/d=
ev/null

Pid: 1138, comm: md0_raid6 Not tainted 5.13.0-rc3-00041-gc82aa1b76787
RIP: 0033:[<00000000602d4922>]
RSP: 0000000063a5fc10  EFLAGS: 00010206
RAX: 0000000100000000 RBX: 000000006274b000 RCX: 00000000949d6f00
RDX: 00000000602a587a RSI: 000000066297ca18 RDI: 00000000619d1550
RBP: 0000000063a5fc40 R08: 0000078200080000 R09: 00000000ffffffff
R10: 0000000061136040 R11: 0000000000000001 R12: 00000000619d1550
R13: 00000000602d491a R14: 000000006283b298 R15: 000000006283a570
Kernel panic - not syncing: Segfault with no mm
CPU: 0 PID: 1138 Comm: md0_raid6 Not tainted 5.13.0-rc3-00041-gc82aa1b76787=
 #71
Stack:
 63a5fc40 602a5920 602a587a 6274b000
 6283b070 619d1550 63a5fda0 6041dfea
 00000000 00000001 63a5fcb0 60061b0c
Call Trace:
 [<602a5920>] ? bio_endio+0xa6/0x152
 [<602a587a>] ? bio_endio+0x0/0x152
 [<6041dfea>] handle_stripe+0xbcf/0x3096
 [<60061b0c>] ? try_to_wake_up+0x19b/0x1ad
 [<6041d41b>] ? handle_stripe+0x0/0x3096
 [<60420831>] handle_active_stripes.constprop.0+0x380/0x458
 [<604175c1>] ? list_del_init+0x0/0x16
 [<60420d6a>] raid5d+0x2f6/0x4aa
 [<6048eb70>] ? __schedule+0x0/0x43f
 [<6005b2df>] ? kthread_should_stop+0x0/0x2c
 [<60038a12>] ? set_signals+0x37/0x3f
 [<60038a12>] ? set_signals+0x37/0x3f
 [<6005b2df>] ? kthread_should_stop+0x0/0x2c
 [<6044b0e2>] md_thread+0x174/0x18a
 [<6006b426>] ? autoremove_wake_function+0x0/0x39
 [<60043b17>] ? do_exit+0x0/0x93a
 [<6044af6e>] ? md_thread+0x0/0x18a
 [<6005b1fe>] kthread+0x168/0x170
 [<600272dd>] new_thread_handler+0x81/0xb2
Aborted

jrayhawk@yuzz:~/src/linux$ sudo ./linux break=3Dtop con=3Dtty:$(tty) mem=3D=
1G $(n=3D1; for i in $( ls /sys/class/block/md0/slaves/ ); do echo -n ubd$(=
(n++))r=3D/dev/${i}" "; done)
[...]
mdadm: /dev/md0 has been started with 13 drives.
/ # dd bs=3D$((1024*64*11)) skip=3D19477214 count=3D1 if=3D/dev/md0 of=3D/d=
ev/null
Buffer I/O error on dev md0, logical block 3427989666, async page read
0+1 records in
0+1 records out
/ # dd bs=3D$((1024*64*11)) skip=3D19477214 count=3D1 if=3D/dev/md0 of=3D/d=
ev/null

Pid: 959, comm: dd Not tainted 5.15.0-rc6-00077-g1a7e76e4f130
RIP: 0033:[<00000000602ae55c>]
RSP: 00000000a2b8f600  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000626acc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000010000 RDI: 00000000626acc00
RBP: 00000000a2b8f610 R08: 00000000ffffff00 R09: 00000000626acc00
R10: 00007fffe39db080 R11: 00007fffe39db090 R12: 0000000000010000
R13: 0000000000010000 R14: 00000000626acc00 R15: 0000000062772af0
Kernel panic - not syncing: Kernel mode fault at addr 0x8, ip 0x602ae55c
CPU: 0 PID: 959 Comm: dd Not tainted 5.15.0-rc6-00077-g1a7e76e4f130 #69
Stack:
 626acc00 626acc00 a2b8f640 602aeb43
 00000020 00000000 621e7000 6255e800
 a2b8f720 6043d5da a2b8f6a0 60798840
Call Trace:
 [<602aeb43>] bio_split+0x11b/0x134
 [<6043d5da>] raid5_make_request+0x17e/0xae9
 [<6003a2ec>] ? os_nsecs+0x1d/0x2b
 [<6006d523>] ? autoremove_wake_function+0x0/0x39
 [<602b62ef>] ? bio_advance_iter_single+0x1a/0x4b
 [<602b6ca6>] ? __blk_queue_split+0x2a6/0x33d
 [<6046aa2e>] ? is_suspended+0x0/0x3e
 [<6046be7f>] md_handle_request+0xcc/0x130
 [<602b0b57>] ? __submit_bio+0x0/0x191
 [<602b0b57>] ? __submit_bio+0x0/0x191
 [<6046c021>] md_submit_bio+0xa3/0xad
 [<602b0cac>] __submit_bio+0x155/0x191
 [<602aca00>] ? bio_next_segment+0x6/0x82
 [<602b03a0>] ? bio_list_pop+0x0/0x23
 [<602b037e>] ? bio_list_merge+0x0/0x22
 [<602b0b57>] ? __submit_bio+0x0/0x191
 [<602b16ee>] submit_bio_noacct+0x174/0x236
 [<60039be6>] ? set_signals+0x0/0x3f
 [<600e123e>] ? readahead_page+0x0/0x98
 [<602b1899>] submit_bio+0xe9/0xf2
 [<604b0567>] ? xa_load+0x0/0x5e
 [<60173cf9>] mpage_bio_submit+0x3b/0x42
 [<60173cbe>] ? mpage_bio_submit+0x0/0x42
 [<60174eae>] mpage_readahead+0x144/0x152
 [<602ac045>] ? blkdev_get_block+0x0/0x32
 [<602abb83>] blkdev_readahead+0x1a/0x1c
 [<600e143a>] read_pages+0x57/0x18b
 [<600e1ec6>] ? get_page+0x10/0x15
 [<600e1787>] page_cache_ra_unbounded+0xef/0x1df
 [<604aff9c>] ? __xas_prev+0x3f/0xe5
 [<600e18b3>] do_page_cache_ra+0x3c/0x3f
 [<600e1aab>] ondemand_readahead+0x1f5/0x204
 [<600e1bd5>] page_cache_sync_ra+0x77/0x7e
 [<600d7f7f>] ? filemap_get_read_batch+0x0/0x112
 [<600daaa4>] filemap_read+0x1ab/0x738
 [<60146d6c>] ? terminate_walk+0x59/0x83
 [<60148abf>] ? path_openat+0x843/0xbb0
 [<600db13f>] generic_file_read_iter+0x10e/0x11d
 [<602abe91>] blkdev_read_iter+0x4c/0x5c
 [<6013922f>] new_sync_read+0x73/0xda
 [<6014558b>] ? putname+0xa9/0xae
 [<60260000>] ? newseg+0x2a8/0x2f0
 [<6013a2be>] vfs_read+0xd0/0x106
 [<60156dd0>] ? __fdget+0x15/0x17
 [<60156df9>] ? __fdget_pos+0x13/0x4a
 [<6013a673>] ksys_read+0x6c/0xa6
 [<6013a6bd>] sys_read+0x10/0x12
 [<6002b5fe>] handle_syscall+0x81/0xb1
 [<6003ba8d>] userspace+0x4af/0x53d
 [<60028446>] fork_handler+0x94/0x96
Aborted

The underlying block devices themselves are fully readable without
error, sync_action check/repair do not make any objections, and
raid6check is entirely happy.

--examine-badblocks output is, however, rather inconsistent:

root@yuzz:~# IFS=3D$'\n'; slaves=3D($(ls /sys/class/block/md0/slaves/)); fo=
r slave in ${slaves[*]}; do mdadm --examine-badblocks /dev/$slave; done | s=
ort -u | sed -n 's/^ \+//p' | while read badblock; do printf '%-25s:' "$bad=
block"; for slave in ${slaves[*]}; do mdadm --examine-badblocks /dev/$slave=
 | grep -q " $badblock"; echo -n " $?"; done; echo; done
2174988544 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174989080 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174990608 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174992144 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174993680 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174995208 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2174996744 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2175000120 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2175001656 for 8 sectors : 0 1 0 1 0 0 0 0 0 1 0 0 0
2493345552 for 16 sectors: 0 1 0 1 0 1 0 0 0 1 0 1 0
2493351832 for 8 sectors : 0 1 0 1 0 1 0 0 0 1 0 1 0
2493356936 for 8 sectors : 0 1 0 1 0 1 0 0 0 1 0 1 0
2493398344 for 16 sectors: 0 1 0 1 0 1 0 0 0 1 0 1 0
2493398584 for 8 sectors : 0 1 0 1 0 1 0 0 0 1 0 1 0

(where "0" is "present" and "1" is "missing")

The relevant read triggering the problem is

19477214*1024*64/512+262144 =3D 2493345536 through 2493411072

which neatly coincides with the 2493345552 through 2493398584 badblocks
entries.

Reading the other (differently inconsistent) badblocks addresses do not
trigger I/O errors or panics.

I don't understand how badblocks got into this inconsistent state or how
to uncorruptedly get it out of this state without copying the entire
array; if anyone has pointers, I would be glad to hear them.

If further information is needed, let me know how to acquire it.

Please CC me in this thread; I am not on the list.
--===============6814218357873234810==
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Description: signature
Content-Type: application/pgp-signature; name="signature.asc"; charset="us-ascii"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE0W3/Ls5On90y4dmX35w74P7tvu8FAmHlwmsACgkQ35w74P7t
vu+59BAAhvmoS8MmZPPqbhiLfDqqw/qgMJARJH9raf/W9T0dBa0Wq3k0of+WO40c
MTzxvZTk75/VJbQrJnVdwoLd3Ej39w3HN2UM1NvlR4xHsWVSa57vGgOmTGhtffPl
XJzKdr1Wp8eV4xViSRsga4oXqoO2/LHF3SLTkna7iHSVZxFMdOtgUsg6lLpog0/A
WEBiT/AvqRRH0MQ3OTpyKjrC1DrneEh1muYlyGbRuzfB/pN1VqnxUECoT+JEvIqs
H+bPkD4sWQKVX73CCgC+cvNFIW1Fwh/eSRfMGM5jmG7jz7qj2zMrxz0D+01Qeq/w
V9sHCYbHTIigMBIy/WH1YuHwgHGRBrkKxC9/1rG0pnQ8LsqtgWgSBYKpKlJFq4p/
IdRPRB7oYn0+4KIkz5XYFO8wJlfGiNDd/AsPOsfbQIuD40la04kGZRrYJd/9jr32
bHpERTg5ndp8n7/0BfBteRS3B+EoTa6maKPXG2ms1APS9r4nwz0Tu+mgUoiLiu7l
3hor/exVhK2mCciMk87k42zw/qVzXMDPe4x8AkxdLJQ6OElCsRMNrEDpJMXA2kSe
f6fxIhF5/8KEWBFOGZ/KzUU6jwP5874tb+rY1I8enu6GL88vx/d6nwUTpcD3JYMy
fy7TUL9L0A0/+OcrmlIOd3weoFruyh5JjybcHgAbzqIpJ6tfwS0=
=xFAm
-----END PGP SIGNATURE-----

--===============6814218357873234810==--
