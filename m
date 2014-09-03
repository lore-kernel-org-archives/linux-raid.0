From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 data corruption during resync
Date: Tue, 2 Sep 2014 20:18:06 -0500
Message-ID: <F9B1D613-79EF-488E-8D41-4C1BDBC6D4BE@redhat.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com> <EAC50175-42D9-43BA-ADE2-1A50BD0581CB@redhat.com> <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com> <20140903095507.032e8c6d@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140903095507.032e8c6d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 2, 2014, at 6:55 PM, NeilBrown wrote:

> On Tue, 2 Sep 2014 15:07:26 -0700 Eivind Sarto <eivindsarto@gmail.com=
> wrote:
>=20
>>=20
>> On Sep 2, 2014, at 12:24 PM, Brassow Jonathan <jbrassow@redhat.com> =
wrote:
>>=20
>>>=20
>>> On Aug 29, 2014, at 2:29 PM, Eivind Sarto wrote:
>>>=20
>>>> I am seeing occasional data corruption during raid1 resync.
>>>> Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc=
231c9a90a278333c21f761 introduced a bug.
>>>> Prior to this commit raise_barrier() used to wait for conf->nr_pen=
ding to become zero.  It no longer does this.
>>>> It is not easy to reproduce the corruption, so I wanted to ask abo=
ut the following potential fix while I am still testing it.
>>>> Once I validate that the fix indeed works, I will post a proper pa=
tch.
>>>> Do you have any feedback?
>>>>=20
>>>> =97 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
>>>> +++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
>>>> @@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
>>>> 	 *    handling.
>>>> 	 */
>>>> 	wait_event_lock_irq(conf->wait_barrier,
>>>> -			    !conf->array_frozen &&
>>>> +			    !conf->array_frozen && !conf->nr_pending &&
>>>> 			    conf->barrier < RESYNC_DEPTH &&
>>>> 			    (conf->start_next_window >=3D
>>>> 			     conf->next_resync + RESYNC_SECTORS),
>>>=20
>>> This patch does not work - at least, it doesn't fix the issues I'm =
seeing.  My system hangs (in various places, like the resync thread) af=
ter commit 79ef3a8.  When testing this patch, I also added some code to=
 dm-raid.c to allow me to print-out some of the variables when I encoun=
ter a problem.  After applying this patch and printing the variables, I=
 see:
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: start_next_windo=
w =3D 12288
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: current_window_r=
equests =3D -46
>>> 5257
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: next_window_requ=
ests =3D -11562
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_pending =3D 0
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_waiting =3D 0
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: nr_queued  =3D 0
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: barrier =3D 1
>>> Sep  2 14:04:15 bp-01 kernel: device-mapper: raid: array_frozen =3D=
 0
>>>=20
>>> Some of those values look pretty bizarre to me and suggest the acco=
unting is pretty messed up.
>>>=20
>>> brassow
>>>=20
>>=20
>> After reviewing commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 I no=
tice that wait_barrier() will now only exclude writes.  User reads are =
not excluded even if the fall within the resync window.
>> The old implementation used to exclude both reads and writes while r=
esync-IO is active.
>> Could this be a cause of data corruption?
>>=20
>=20
> Could be.
> From read_balance:
>=20
> 	if (conf->mddev->recovery_cp < MaxSector &&
> 	    (this_sector + sectors >=3D conf->next_resync))
> 		choose_first =3D 1;
> 	else
> 		choose_first =3D 0;
>=20
> This used to be safe because a read immediately before next_resync wo=
uld wait
> until all resync requests completed.  But now that read requests don'=
t block
> it isn't safe.
> Probably best to make this:
>=20
>    choose_first =3D (conf->mddev->recovery_cp < this_sector + sectors=
);
>=20
> Can you test that?

Unfortunately, I doubt very much that that will solve the issue that I =
am seeing.  (Although, I'd welcome this fix also.)

I have predominantly been testing RHEL kernels, but I've seen this with=
 the latest upstream kernel as well.  When doing fault testing, like fa=
iling a drive while the resync is happening, the processes can become h=
ung.  Here's one example, but they vary:

INFO: task mdX_resync:11334 blocked for more than 120 seconds.         =
        =20
      Not tainted 2.6.32-497.el6.x86_64 #1                             =
        =20
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.      =20
mdX_resync    D 0000000000000000     0 11334      2 0x00000080         =
        =20
 ffff8801fada5be0 0000000000000046 ffff88021a3bcc00 0000000300000001   =
        =20
 ffff880218b92200 ffff880218668f50 0000000000000282 0000000000000003   =
        =20
 0000000000000001 0000000000000282 ffff88021bfb45f8 ffff8801fada5fd8   =
        =20
Call Trace:                                                            =
        =20
 [<ffffffff8140e439>] ? md_wakeup_thread+0x39/0x70                     =
        =20
 [<ffffffffa02b81dd>] sync_request+0x26d/0xb90 [raid1]                 =
        =20
 [<ffffffff81064b90>] ? default_wake_function+0x0/0x20                 =
        =20
 [<ffffffff810577e9>] ? __wake_up_common+0x59/0x90                     =
        =20
 [<ffffffff8109eb00>] ? autoremove_wake_function+0x0/0x40              =
        =20
 [<ffffffff8105bd23>] ? __wake_up+0x53/0x70                            =
        =20
 [<ffffffff81414a47>] md_do_sync+0x6c7/0xd20                           =
        =20
 [<ffffffff814154f5>] md_thread+0x115/0x150                            =
        =20
 [<ffffffff814153e0>] ? md_thread+0x0/0x150                            =
        =20
 [<ffffffff8109e66e>] kthread+0x9e/0xc0                                =
        =20
 [<ffffffff8100c20a>] child_rip+0xa/0x20                               =
        =20
 [<ffffffff8109e5d0>] ? kthread+0x0/0xc0                               =
        =20
 [<ffffffff8100c200>] ? child_rip+0x0/0x20                             =
        =20


and...


INFO: task kjournald:10732 blocked for more than 120 seconds.          =
        =20
      Not tainted 2.6.32-497.el6.x86_64 #1                             =
        =20
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.      =20
kjournald     D 0000000000000008     0 10732      2 0x00000080         =
        =20
 ffff8801d71238b0 0000000000000046 0000000000000000 0000000300000001   =
        =20
 ffff880218b92200 ffff880218668f50 000003783fd7424b 0000000000000003   =
        =20
 0000000000000001 000000010035a163 ffff880219135af8 ffff8801d7123fd8   =
        =20
Call Trace:                                                            =
        =20
 [<ffffffffa02b463f>] wait_barrier+0xcf/0x280 [raid1]                  =
        =20
 [<ffffffff8109eb00>] ? autoremove_wake_function+0x0/0x40              =
        =20
 [<ffffffffa02b71bf>] make_request+0x8f/0xe40 [raid1]                  =
        =20
 [<ffffffff81126af5>] ? mempool_alloc_slab+0x15/0x20                   =
        =20
 [<ffffffff81126c93>] ? mempool_alloc+0x63/0x140                       =
        =20
 [<ffffffff811c9d6b>] ? bio_alloc_bioset+0x5b/0xf0                     =
        =20
 [<ffffffffa02cf018>] raid_map+0x18/0x20 [dm_raid]

Bisecting has revealed that the commit that is the subject of this thre=
ad is the root of the problem.  It does take a long time to reproduce t=
he issue with the scripts that I have, but if there is info I can get y=
ou, let me know.

 brassow


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
