From: NeilBrown <neilb@suse.com>
Subject: Re: Calling block ops when !TASK_RUNNING warning in raid1
Date: Thu, 30 Nov 2017 15:26:06 +1100
Message-ID: <87vahsv1cx.fsf@notabene.neil.brown.name>
References: <CAKTMprOTWf04=433GAhpUYs_UXsw1qgiqpRCRs9zEU0K-GP8Hw@mail.gmail.com> <20171128175222.zntgvtxaa4kzbtlw@kernel.org> <87y3movcqp.fsf@notabene.neil.brown.name> <840098d9-8e39-22b3-f903-bf046ab92b86@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <840098d9-8e39-22b3-f903-bf046ab92b86@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>, Dennis Yang <shinrairis@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30 2017, Guoqing Jiang wrote:

> On 11/30/2017 08:20 AM, NeilBrown wrote:
>> On Tue, Nov 28 2017, Shaohua Li wrote:
>>
>>> On Tue, Nov 28, 2017 at 04:51:25PM +0800, Dennis Yang wrote:
>>>> Hi,
>>>>
>>>> We recently see the following kernel dump on raid1 with some kernel
>>>> debug option on.
>>>>
>>>> <4>[   40.501369] ------------[ cut here ]------------
>>>> <4>[   40.501375] WARNING: CPU: 7 PID: 7477 at
>>>> kernel/sched/core.c:7404 __might_sleep+0xa2/0xb0()
>>>> <4>[   40.501378] do not call blocking ops when !TASK_RUNNING; state=
=3D2
>>>> set at [<ffffffff810c28d8>] prepare_to_wait_event+0x58/0x100
>>>> <4>[   40.501379] Modules linked in: dm_c2f(O) pl2303 usbserial
>>>> qm2_i2c(O) intel_ips drbd(O) flashcache(O) dm_tier_hro_algo
>>>> dm_thin_pool dm_bio_prison dm_persistent_data hal_netlink(O) k10temp
>>>> coretemp mlx4_en(O) mlx4_core(O) mlx_compat(O) igb e1000e(O)
>>>> mpt3sas(O) mpt2sas scsi_transport_sas raid_class usb_storage xhci_pci
>>>> xhci_hcd usblp uhci_hcd ehci_pci ehci_hcd
>>>> <4>[   40.501395] CPU: 7 PID: 7477 Comm: md321_resync Tainted: G
>>>>      O    4.2.8 #1
>>>> <4>[   40.501396] Hardware name: INSYDE QV96/Type2 - Board Product
>>>> Name1, BIOS QV96IR23 10/21/2015
>>>> <4>[   40.501397]  ffffffff8219aff7 ffff880092f7b868 ffffffff81c86c4b
>>>> ffffffff810dfb59
>>>> <4>[   40.501399]  ffff880092f7b8b8 ffff880092f7b8a8 ffffffff81079fa5
>>>> ffff880092f7b8e8
>>>> <4>[   40.501401]  ffffffff821a4f6d 0000000000000140 0000000000000000
>>>> 0000000000000001
>>>> <4>[   40.501403] Call Trace:
>>>> <4>[   40.501407]  [<ffffffff81c86c4b>] dump_stack+0x4c/0x65
>>>> <4>[   40.501409]  [<ffffffff810dfb59>] ? console_unlock+0x279/0x4f0
>>>> <4>[   40.501411]  [<ffffffff81079fa5>] warn_slowpath_common+0x85/0xc0
>>>> <4>[   40.501412]  [<ffffffff8107a021>] warn_slowpath_fmt+0x41/0x50
>>>> <4>[   40.501414]  [<ffffffff810c28d8>] ? prepare_to_wait_event+0x58/0=
x100
>>>> <4>[   40.501415]  [<ffffffff810c28d8>] ? prepare_to_wait_event+0x58/0=
x100
>>>> <4>[   40.501416]  [<ffffffff810a4f72>] __might_sleep+0xa2/0xb0
>>>> <4>[   40.501419]  [<ffffffff8117bb7c>] mempool_alloc+0x7c/0x150
>>>> <4>[   40.501422]  [<ffffffff8101442a>] ? save_stack_trace+0x2a/0x50
>>>> <4>[   40.501425]  [<ffffffff8145b589>] bio_alloc_bioset+0xb9/0x260
>>>> <4>[   40.501428]  [<ffffffff816cb6da>] bio_alloc_mddev+0x1a/0x30
>>>> <4>[   40.501429]  [<ffffffff816d22a2>] md_super_write+0x32/0x90
>>>> <4>[   40.501431]  [<ffffffff816db9b2>] write_page+0x2d2/0x480
>>>> <4>[   40.501432]  [<ffffffff816db808>] ? write_page+0x128/0x480
>>>> <4>[   40.501434]  [<ffffffff816a45cc>] ? flush_pending_writes+0x1c/0x=
e0
>>>> <4>[   40.501435]  [<ffffffff816dc2a6>] bitmap_unplug+0x156/0x170
>>>> <4>[   40.501437]  [<ffffffff810caa2d>] ? trace_hardirqs_on+0xd/0x10
>>>> <4>[   40.501439]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x=
40
>>>> <4>[   40.501440]  [<ffffffff816a4613>] flush_pending_writes+0x63/0xe0
>>>> <4>[   40.501442]  [<ffffffff816a4aff>] freeze_array+0x6f/0xc0
>>>> <4>[   40.501443]  [<ffffffff810c27e0>] ? wait_woken+0xb0/0xb0
>>>> <4>[   40.501444]  [<ffffffff816a4b8f>] raid1_quiesce+0x3f/0x50
>>>> <4>[   40.501446]  [<ffffffff816d2254>] md_do_sync+0x1394/0x13b0
>>>> <4>[   40.501447]  [<ffffffff816d1531>] ? md_do_sync+0x671/0x13b0
>>>> <4>[   40.501449]  [<ffffffff810cb680>] ? __lock_acquire+0x990/0x23a0
>>>> <4>[   40.501451]  [<ffffffff810bade7>] ? pick_next_task_fair+0x707/0x=
c30
>>>> <4>[   40.501453]  [<ffffffff8108783c>] ? kernel_sigaction+0x2c/0xc0
>>>> <4>[   40.501455]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x=
40
>>>> <4>[   40.501456]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
>>>> <4>[   40.501457]  [<ffffffff816cadbe>] md_thread+0x13e/0x150
>>>> <4>[   40.501458]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
>>>> <4>[   40.501460]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
>>>> <4>[   40.501462]  [<ffffffff8109ded5>] kthread+0x105/0x120
>>>> <4>[   40.501463]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x=
40
>>>> <4>[   40.501465]  [<ffffffff8109ddd0>] ? kthread_create_on_node+0x220=
/0x220
>>>> <4>[   40.501467]  [<ffffffff81c956cf>] ret_from_fork+0x3f/0x70
>>>> <4>[   40.501468]  [<ffffffff8109ddd0>] ? kthread_create_on_node+0x220=
/0x220
>>>> <4>[   40.501469] ---[ end trace bd085fb137be2a87 ]---
>>>>
>>>> It looks like raid1_quiesce() creates a nested sleeping primitives by
>>>> calling wait_event_lock_irq_cmd()
>>>> first to change the state to TASK_UNINTERRUPTIBLE and
>>>> flush_pending_writes() could eventually try
>>>> to allocate bio for bitmap update with GFP_NOIO which might sleep and
>>>> triggers this warning.
>>>> I am not sure if this warning is just a false-positive or should we
>>>> change the bio allocation
>>>> gfp flag to GFP_NOWAIT to prevent it from blocking?
>>> This is a legit warnning. Changing gfp to GFP_NOWAIT doesn't completely=
 fix the
>>> issue, because generic_make_request could sleep too. I think we should =
move the
>>> work to a workqueue. Could you please try below patch (untested yet)?
>> I think it would be simpler to call __set_current_state(TASK_RUNNING)
>> in the 'then' branch of flush_pending_writes().
>
> There is no 'then' branch in this function, maybe you mean set=20
> TASK_RUNNING in the 'if' branch,
> since the calltrace is triggered by flush_pending_writes ->=20
> flush_bio_list -> bitmap_unplug.

I grew up with BASIC and Pascal.
Every "if" statement has a "then" branch and an "else" branch.
The fact that C doesn't have a "then" keyword doesn't mean there isn't a
'then' branch.

But yes, state should be set to TASK_RUNNING when the condition in the
'if' statement evaluates as 'true' (or maybe I should say "doesn't
evaluate to 0").

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlofiF4ACgkQOeye3VZi
gbmzOg//VV3JOTe34uZRk5OeAFeVX4V9No1ym/q+o6jW9E6d/siA0YdIujfVBAU8
F65NtbOdoFIqOc25yxP3xRuqKTRlsUsOCflVNdoV17hGtSNJa+6/CqjgqdVg9Bq7
Zn7Diw6Idlq1a/FazLbj5rVdq9HFWCyZ8qVRkic47S3Mkq+8fVchb9ODA8Rzkhgk
RxvOJlzEV4GudZwMec9rOnzL8fUE3BP/HuIeB1F5YXGPz/PSlVihrEvBEmlAsjd/
jaJ3L6Bq9/jiZHD0/hxP3pXFwRPf7a5uWAzgsGh6u9CSA8ucAbSmkJRCKd06Ozun
5DHN7wx3xaZbmOWXFYicpfKCUGL80uuLWzMYcc1P9WcCxBJ24WUlsY2S9iHi/Qef
6Rk9QZaiqHyuNa9HSovpxPU8ATHEbMOCWmist//s+WeL7u1+piiidxh4tXyih4ru
ii+16i6Pv7mfKb+JXB/SREKhV4/iGPgPL8Ec7JdfICd5LXnjzyu5ZRd88lCEuhMT
80sTU2lMAzTI+dNBx3XstgPxp6QF0WfR93b6A2lcfKYW/tWniIlZMbrAbk1t2ejp
fgObKBeti/8NWW6/oREHE1qe6FucrtcCscaozOlAsRhpW0djdOpB6/Fppz1T/fVM
BNKGhNYmV5sFfITKl7B2e2yUeakmLoqPDBO3W43ye5bcePHCqy8=
=5MHz
-----END PGP SIGNATURE-----
--=-=-=--
