From: qindehua <qindehua@163.com>
Subject: Re: Problem with disk replacement
Date: Fri, 16 Aug 2013 18:26:25 +0800 (CST)
Message-ID: <83c2b0f.1c4ca.14086a9703f.Coremail.qindehua@163.com>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
 <7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
 <20130722130415.44b85e93@notabene.brown>
 <3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
 <20130723132124.3bb0bcaf@notabene.brown>
 <b97941b.229e0.14010b931c5.Coremail.qindehua@163.com>
 <20130725164531.72f316c8@notabene.brown>
 <20130725173253.11ec4ec6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130725173253.11ec4ec6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

There is a WARN_ON in the patch "md/raid5: fix interaction of 'replace'=
 and 'recovery'", which can happen by following test,
is there any problem?

Here is the steps to produce the WARNING messages:
1. create 3-drives RAID5 with --force
   mdadm -C /dev/md1 --force -l 5 -n 3 /dev/sd[b-d]

2. while the raid is resyncing, replace one disk with follow commands:
   mdadm /dev/md1 -a /dev/sde
   mdadm /dev/md1 --replace /dev/sdb
   echo "idle" >  /sys/block/md1/md/sync_action

After a while the raid5 module prints lots of WARNING messages which is=
 introduced by the patch of "md/raid5: fix interaction of 'replace' and=
 'recovery'". The code context is:

	if ((s.replacing || s.syncing) && s.locked =3D=3D 0
	    && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
		/* Write out to replacement devices where possible */
		for (i =3D 0; i < conf->raid_disks; i++)
			if (test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
				WARN_ON(!test_bit(R5_UPTODATE, &sh->dev[i].flags));
				set_bit(R5_WantReplace, &sh->dev[i].flags);
				set_bit(R5_LOCKED, &sh->dev[i].flags);
				s.locked++;
			}

The WARNING messages:
[ 1667.432071] ------------[ cut here ]------------
[ 1667.433522] WARNING: at drivers/md/raid5.c:3611 handle_stripe+0x1175=
/0x1e15()
[ 1667.435566] Hardware name: VirtualBox
[ 1667.438395] Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O) d=
evice_buffer(O) mem_mgnt(PO) fuse
[ 1667.441955] Pid: 4670, comm: md1_raid5 Tainted: P        W  O 3.9.6 =
#1
[ 1667.443551] Call Trace:
[ 1667.445093]  [<ffffffff8103f0ea>] warn_slowpath_common+0x7a/0xc0
[ 1667.445093]  [<ffffffff8103f145>] warn_slowpath_null+0x15/0x20
[ 1667.447816]  [<ffffffff815d8479>] handle_stripe+0x1175/0x1e15
[ 1667.449638]  [<ffffffff812fe5da>] ? rb_erase_init+0x23/0x30
[ 1667.451527]  [<ffffffff81126572>] ? kmem_cache_alloc+0x62/0x140
[ 1667.453506]  [<ffffffff812e8b52>] ? sg_set_page+0x29/0x3f
[ 1667.455304]  [<ffffffff812e9445>] ? __blk_segment_map_sg+0x209/0x22c
[ 1667.457224]  [<ffffffff812e96fa>] ? blk_rq_map_sg+0x292/0x29e
[ 1667.459684]  [<ffffffff814aa2c2>] ? ahci_qc_prep+0x132/0x180
[ 1667.461397]  [<ffffffff81859699>] ? _raw_spin_unlock_irqrestore+0x9/=
0x10
[ 1667.462912]  [<ffffffff815e13b4>] ? test_ti_thread_flag+0x24/0x26
[ 1667.464560]  [<ffffffff815e1952>] ? test_tsk_thread_flag+0x24/0x26
[ 1667.466207]  [<ffffffff815e1971>] ? signal_pending+0x1d/0x27
[ 1667.468156]  [<ffffffff815fba4e>] ? md_check_recovery+0x60/0xcc3
[ 1667.470134]  [<ffffffff81455292>] ? put_device+0x12/0x20
[ 1667.471449]  [<ffffffff81472c2a>] ? scsi_request_fn+0x9a/0x4a0
[ 1667.473183]  [<ffffffff812fd3f9>] ? blk_rq_sectors+0x18/0x1d
[ 1667.475422]  [<ffffffff81077ebd>] ? dequeue_task_fair+0x40d/0x920
[ 1667.477118]  [<ffffffff810744b0>] ? set_next_entity+0xa0/0xc0
[ 1667.477118]  [<ffffffff810754b3>] ? pick_next_task_fair+0x63/0x140
[ 1667.480396]  [<ffffffff815c9b0e>] ? list_del_init+0x24/0x26
[ 1667.483181]  [<ffffffff815f7907>] ? md_revalidate+0x30/0x30
[ 1667.484935]  [<ffffffff815dc76c>] handle_active_stripes+0x7f/0xeb
[ 1667.486274]  [<ffffffff815dc93c>] raid5d+0x164/0x20a
[ 1667.488076]  [<ffffffff815f7b9b>] md_thread+0x294/0x2b3
[ 1667.488076]  [<ffffffff81062750>] ? add_wait_queue+0x60/0x60
[ 1667.491532]  [<ffffffff81061ebb>] kthread+0xbb/0xc0
[ 1667.493266]  [<ffffffff81061e00>] ? flush_kthread_work+0x120/0x120
[ 1667.494953]  [<ffffffff8186122c>] ret_from_fork+0x7c/0xb0
[ 1667.496337]  [<ffffffff81061e00>] ? flush_kthread_work+0x120/0x120
[ 1667.498159] ---[ end trace 6c53bec353931415 ]---

Regards,
Qin Dehua

At=C2=A02013-07-25=C2=A015:32:53,NeilBrown=C2=A0<neilb@suse.de>=C2=A0wr=
ote:
>On=C2=A0Thu,=C2=A025=C2=A0Jul=C2=A02013=C2=A016:45:31=C2=A0+1000=C2=A0=
NeilBrown=C2=A0<neilb@suse.de>=C2=A0wrote:
>
>Hi=C2=A0again.
>
>Here=C2=A0is=C2=A0the=C2=A0patch=C2=A0which=C2=A0I=C2=A0think=C2=A0is=C2=
=A0correct=C2=A0and=C2=A0I=C2=A0hope=C2=A0to=C2=A0submit=C2=A0tomorrow.
>
>NeilBrown
>
>
>From=C2=A0f94c0b6658c7edea8bc19d13be321e3860a3fa54=C2=A0Mon=C2=A0Sep=C2=
=A017=C2=A000:00:00=C2=A02001
>From:=C2=A0NeilBrown=C2=A0<neilb@suse.de>
>Date:=C2=A0Mon,=C2=A022=C2=A0Jul=C2=A02013=C2=A012:57:21=C2=A0+1000
>Subject:=C2=A0[PATCH]=C2=A0md/raid5:=C2=A0fix=C2=A0interaction=C2=A0of=
=C2=A0'replace'=C2=A0and=C2=A0'recovery'.
>
>If=C2=A0a=C2=A0device=C2=A0in=C2=A0a=C2=A0RAID4/5/6=C2=A0is=C2=A0being=
=C2=A0replaced=C2=A0while=C2=A0another=C2=A0is=C2=A0being
>recovered,=C2=A0then=C2=A0the=C2=A0writes=C2=A0to=C2=A0the=C2=A0replac=
ement=C2=A0device=C2=A0currently=C2=A0don't
>happen,=C2=A0resulting=C2=A0in=C2=A0corruption=C2=A0when=C2=A0the=C2=A0=
replacement=C2=A0completes=C2=A0and=C2=A0the
>new=C2=A0drive=C2=A0takes=C2=A0over.
>
>This=C2=A0is=C2=A0because=C2=A0the=C2=A0replacement=C2=A0writes=C2=A0a=
re=C2=A0only=C2=A0triggered=C2=A0when
>'s.replacing'=C2=A0is=C2=A0set=C2=A0and=C2=A0not=C2=A0when=C2=A0the=C2=
=A0similar=C2=A0's.sync'=C2=A0is=C2=A0set=C2=A0(which
>is=C2=A0the=C2=A0case=C2=A0during=C2=A0resync=C2=A0and=C2=A0recovery=C2=
=A0-=C2=A0it=C2=A0means=C2=A0all=C2=A0devices=C2=A0need=C2=A0to
>be=C2=A0read).
>
>So=C2=A0schedule=C2=A0those=C2=A0writes=C2=A0when=C2=A0s.replacing=C2=A0=
is=C2=A0set=C2=A0as=C2=A0well.
>
>In=C2=A0this=C2=A0case=C2=A0we=C2=A0cannot=C2=A0use=C2=A0"STRIPE_INSYN=
C"=C2=A0to=C2=A0record=C2=A0that=C2=A0the
>replacement=C2=A0has=C2=A0happened=C2=A0as=C2=A0that=C2=A0is=C2=A0need=
ed=C2=A0for=C2=A0recording=C2=A0that=C2=A0any
>parity=C2=A0calculation=C2=A0is=C2=A0complete.=C2=A0=C2=A0So=C2=A0intr=
oduce=C2=A0STRIPE_REPLACED=C2=A0to
>record=C2=A0if=C2=A0the=C2=A0replacement=C2=A0has=C2=A0happened.
>
>For=C2=A0safety=C2=A0we=C2=A0should=C2=A0also=C2=A0check=C2=A0that=C2=A0=
STRIPE_COMPUTE_RUN=C2=A0is=C2=A0not=C2=A0set.
>This=C2=A0has=C2=A0a=C2=A0similar=C2=A0effect=C2=A0to=C2=A0the=C2=A0"s=
=2Elocked=C2=A0=3D=3D=C2=A00"=C2=A0test.=C2=A0=C2=A0The=C2=A0latter
>ensure=C2=A0that=C2=A0now=C2=A0IO=C2=A0has=C2=A0been=C2=A0flagged=C2=A0=
but=C2=A0not=C2=A0started.=C2=A0=C2=A0The=C2=A0former
>checks=C2=A0if=C2=A0any=C2=A0parity=C2=A0calculation=C2=A0has=C2=A0bee=
n=C2=A0flagged=C2=A0by=C2=A0not=C2=A0started.
>We=C2=A0must=C2=A0wait=C2=A0for=C2=A0both=C2=A0of=C2=A0these=C2=A0to=C2=
=A0complete=C2=A0before=C2=A0triggering=C2=A0the
>'replace'.
>
>Add=C2=A0a=C2=A0similar=C2=A0test=C2=A0to=C2=A0the=C2=A0subsequent=C2=A0=
check=C2=A0for=C2=A0"are=C2=A0we=C2=A0finished=C2=A0yet".
>This=C2=A0possibly=C2=A0isn't=C2=A0needed=C2=A0(is=C2=A0subsumed=C2=A0=
in=C2=A0the=C2=A0STRIPE_INSYNC=C2=A0test),
>but=C2=A0it=C2=A0makes=C2=A0it=C2=A0more=C2=A0obvious=C2=A0that=C2=A0t=
he=C2=A0REPLACE=C2=A0will=C2=A0happen=C2=A0before=C2=A0we
>think=C2=A0we=C2=A0are=C2=A0finished.
>
>Finally=C2=A0if=C2=A0a=C2=A0NeedReplace=C2=A0device=C2=A0is=C2=A0not=C2=
=A0UPTODATE=C2=A0then=C2=A0that=C2=A0is=C2=A0an
>error.=C2=A0=C2=A0We=C2=A0really=C2=A0must=C2=A0trigger=C2=A0a=C2=A0wa=
rning.
>
>This=C2=A0bug=C2=A0was=C2=A0introduced=C2=A0in=C2=A0commit=C2=A09a3e11=
01b827a59ac9036a672f5fa8d5279d0fe2
>(md/raid5:=C2=A0=C2=A0detect=C2=A0and=C2=A0handle=C2=A0replacements=C2=
=A0during=C2=A0recovery.)
>which=C2=A0introduced=C2=A0replacement=C2=A0for=C2=A0raid5.
>That=C2=A0was=C2=A0in=C2=A03.3-rc3,=C2=A0so=C2=A0any=C2=A0stable=C2=A0=
kernel=C2=A0since=C2=A0then=C2=A0would=C2=A0benefit
>from=C2=A0this=C2=A0fix.
>
>Cc:=C2=A0stable@vger.kernel.org=C2=A0(3.3+)
>Reported-by:=C2=A0qindehua=C2=A0<13691222965@163.com>
>Tested-by:=C2=A0qindehua=C2=A0<qindehua@163.com>
>Signed-off-by:=C2=A0NeilBrown=C2=A0<neilb@suse.de>
>
>diff=C2=A0--git=C2=A0a/drivers/md/raid5.c=C2=A0b/drivers/md/raid5.c
>index=C2=A02bf094a..78ea443=C2=A0100644
>---=C2=A0a/drivers/md/raid5.c
>+++=C2=A0b/drivers/md/raid5.c
>@@=C2=A0-3462,6=C2=A0+3462,7=C2=A0@@=C2=A0static=C2=A0void=C2=A0handle=
_stripe(struct=C2=A0stripe_head=C2=A0*sh)
>=C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0test_and_clear_bit(STRIPE_SYNC_REQUEST=
ED,=C2=A0&sh->state))=C2=A0{
>=C2=A0			set_bit(STRIPE_SYNCING,=C2=A0&sh->state);
>=C2=A0			clear_bit(STRIPE_INSYNC,=C2=A0&sh->state);
>+			clear_bit(STRIPE_REPLACED,=C2=A0&sh->state);
>=C2=A0		}
>=C2=A0		spin_unlock(&sh->stripe_lock);
>=C2=A0	}
>@@=C2=A0-3607,19=C2=A0+3608,23=C2=A0@@=C2=A0static=C2=A0void=C2=A0hand=
le_stripe(struct=C2=A0stripe_head=C2=A0*sh)
>=C2=A0			handle_parity_checks5(conf,=C2=A0sh,=C2=A0&s,=C2=A0disks);
>=C2=A0	}
>=C2=A0
>-	if=C2=A0(s.replacing=C2=A0&&=C2=A0s.locked=C2=A0=3D=3D=C2=A00
>-	=C2=A0=C2=A0=C2=A0=C2=A0&&=C2=A0!test_bit(STRIPE_INSYNC,=C2=A0&sh->s=
tate))=C2=A0{
>+	if=C2=A0((s.replacing=C2=A0||=C2=A0s.syncing)=C2=A0&&=C2=A0s.locked=C2=
=A0=3D=3D=C2=A00
>+	=C2=A0=C2=A0=C2=A0=C2=A0&&=C2=A0!test_bit(STRIPE_COMPUTE_RUN,=C2=A0&=
sh->state)
>+	=C2=A0=C2=A0=C2=A0=C2=A0&&=C2=A0!test_bit(STRIPE_REPLACED,=C2=A0&sh-=
>state))=C2=A0{
>=C2=A0		/*=C2=A0Write=C2=A0out=C2=A0to=C2=A0replacement=C2=A0devices=C2=
=A0where=C2=A0possible=C2=A0*/
>=C2=A0		for=C2=A0(i=C2=A0=3D=C2=A00;=C2=A0i=C2=A0<=C2=A0conf->raid_dis=
ks;=C2=A0i++)
>-			if=C2=A0(test_bit(R5_UPTODATE,=C2=A0&sh->dev[i].flags)=C2=A0&&
>-			=C2=A0=C2=A0=C2=A0=C2=A0test_bit(R5_NeedReplace,=C2=A0&sh->dev[i].=
flags))=C2=A0{
>+			if=C2=A0(test_bit(R5_NeedReplace,=C2=A0&sh->dev[i].flags))=C2=A0{
>+				WARN_ON(!test_bit(R5_UPTODATE,=C2=A0&sh->dev[i].flags));
>=C2=A0				set_bit(R5_WantReplace,=C2=A0&sh->dev[i].flags);
>=C2=A0				set_bit(R5_LOCKED,=C2=A0&sh->dev[i].flags);
>=C2=A0				s.locked++;
>=C2=A0			}
>-		set_bit(STRIPE_INSYNC,=C2=A0&sh->state);
>+		if=C2=A0(s.replacing)
>+			set_bit(STRIPE_INSYNC,=C2=A0&sh->state);
>+		set_bit(STRIPE_REPLACED,=C2=A0&sh->state);
>=C2=A0	}
>=C2=A0	if=C2=A0((s.syncing=C2=A0||=C2=A0s.replacing)=C2=A0&&=C2=A0s.lo=
cked=C2=A0=3D=3D=C2=A00=C2=A0&&
>+	=C2=A0=C2=A0=C2=A0=C2=A0!test_bit(STRIPE_COMPUTE_RUN,=C2=A0&sh->stat=
e)=C2=A0&&
>=C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0test_bit(STRIPE_INSYNC,=C2=A0&sh->state=
))=C2=A0{
>=C2=A0		md_done_sync(conf->mddev,=C2=A0STRIPE_SECTORS,=C2=A01);
>=C2=A0		clear_bit(STRIPE_SYNCING,=C2=A0&sh->state);
>diff=C2=A0--git=C2=A0a/drivers/md/raid5.h=C2=A0b/drivers/md/raid5.h
>index=C2=A0b0b663b..70c4932=C2=A0100644
>---=C2=A0a/drivers/md/raid5.h
>+++=C2=A0b/drivers/md/raid5.h
>@@=C2=A0-306,6=C2=A0+306,7=C2=A0@@=C2=A0enum=C2=A0{
>=C2=A0	STRIPE_SYNC_REQUESTED,
>=C2=A0	STRIPE_SYNCING,
>=C2=A0	STRIPE_INSYNC,
>+	STRIPE_REPLACED,
>=C2=A0	STRIPE_PREREAD_ACTIVE,
>=C2=A0	STRIPE_DELAYED,
>=C2=A0	STRIPE_DEGRADED,
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
