From: qindehua <qindehua@163.com>
Subject: Re: Problem with disk replacement
Date: Wed, 24 Jul 2013 20:48:27 +0800 (CST)
Message-ID: <b97941b.229e0.14010b931c5.Coremail.qindehua@163.com>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
 <7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
 <20130722130415.44b85e93@notabene.brown>
 <3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
 <20130723132124.3bb0bcaf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130723132124.3bb0bcaf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
I found another problem that the raid5 thread may run into an endless l=
oop in a rare circumstance.

I have tested with or without the patch of "md/raid5: fix interaction o=
f 'replace' and 'recovery'",
the problem will not happen without the patch. So it is the patch that =
introduce this problem.

Here is the fast steps to reproduce the problem:
1. create 3-drives RAID5 with --assume-clean (I use 1GB disks in Virtua=
lBox machine)
   mdadm -C /dev/md1 -l 5 -n 3 --assume-clean /dev/sd[b-d]

2. change speed_limit_min and speed_limit_max to small number:
   echo 1 > /proc/sys/dev/raid/speed_limit_min
   echo 10 > /proc/sys/dev/raid/speed_limit_max

3. add three spare disks to the raid:
   mdadm /dev/md1 -a /dev/sde -a /dev/sdf -a /dev/sdg

4. replace three raid disks with this procedure:
   	for disk in sdb sdc sdd
	do
		mdadm /dev/md1 --replace /dev/$disk
		echo "idle" >  /sys/block/md1/md/sync_action
		sleep 3
	done

After step 4 the md1_raid5 process then ran into endless loop with 99% =
CPU usage.
The problem will not happen if there is no step 2. Also it will not hap=
pen if
only two disks were replaced.

Regards,
Qin Dehua

At=C2=A02013-07-23=C2=A011:21:24,NeilBrown=C2=A0<neilb@suse.de>=C2=A0wr=
ote:
>On=C2=A0Mon,=C2=A022=C2=A0Jul=C2=A02013=C2=A018:23:57=C2=A0+0800=C2=A0=
(CST)=C2=A0qindehua=C2=A0<qindehua@163.com>=C2=A0wrote:
>
>>=C2=A0Hi=C2=A0Neil,
>>=C2=A0I=C2=A0have=C2=A0tested=C2=A0with=C2=A0this=C2=A0patch,=C2=A0an=
d=C2=A0it=C2=A0fixes=C2=A0the=C2=A0problem.
>>=C2=A0I=C2=A0have=C2=A0also=C2=A0tried=C2=A0various=C2=A0combinations=
=C2=A0of=C2=A0failing=C2=A0and=C2=A0replacing=C2=A0disks,
>>=C2=A0with=C2=A0echo=C2=A0idle=C2=A0to=C2=A0/sys/block/md1/md/sync_ac=
tion,=C2=A0they=C2=A0all=C2=A0work=C2=A0fine.
>>=C2=A0
>>=C2=A0Regards,
>>=C2=A0Qin=C2=A0Dehua
>
>Thanks=C2=A0for=C2=A0confirming,=C2=A0and=C2=A0for=C2=A0all=C2=A0of=C2=
=A0your=C2=A0testing!
>
>I'll=C2=A0forward=C2=A0the=C2=A0patch=C2=A0to=C2=A0Linus=C2=A0shortly.
>
>NeilBrown
>
>
>
>>=C2=A0
>>=C2=A0At=C2=A02013-07-22=C2=A011:04:15,NeilBrown=C2=A0<neilb@suse.de>=
=C2=A0wrote:
>>=C2=A0>Hi=C2=A0Qin,
>>=C2=A0>=C2=A0thanks=C2=A0for=C2=A0the=C2=A0report.=C2=A0=C2=A0I=C2=A0=
can=C2=A0easily=C2=A0reproduce=C2=A0the=C2=A0bug.
>>=C2=A0>
>>=C2=A0>I=C2=A0think=C2=A0this=C2=A0will=C2=A0fix=C2=A0it.=C2=A0=C2=A0=
Could=C2=A0you=C2=A0please=C2=A0test=C2=A0and=C2=A0confirm=C2=A0that=C2=
=A0it=C2=A0fixes
>>=C2=A0>the=C2=A0problem=C2=A0for=C2=A0you=C2=A0too.
>>=C2=A0>
>>=C2=A0>Thanks,
>>=C2=A0>NeilBrown
>>=C2=A0>
>>=C2=A0>
>>=C2=A0>From:=C2=A0NeilBrown=C2=A0<neilb@suse.de>
>>=C2=A0>Date:=C2=A0Mon,=C2=A022=C2=A0Jul=C2=A02013=C2=A012:57:21=C2=A0=
+1000
>>=C2=A0>Subject:=C2=A0[PATCH]=C2=A0md/raid5:=C2=A0fix=C2=A0interaction=
=C2=A0of=C2=A0'replace'=C2=A0and=C2=A0'recovery'.
>>=C2=A0>
>>=C2=A0>If=C2=A0a=C2=A0device=C2=A0in=C2=A0a=C2=A0RAID4/5/6=C2=A0is=C2=
=A0being=C2=A0replaced=C2=A0while=C2=A0another=C2=A0is=C2=A0being
>>=C2=A0>recovered,=C2=A0then=C2=A0the=C2=A0writes=C2=A0to=C2=A0the=C2=A0=
replacement=C2=A0device=C2=A0currently=C2=A0don't
>>=C2=A0>happen,=C2=A0resulting=C2=A0in=C2=A0corruption=C2=A0when=C2=A0=
the=C2=A0replacement=C2=A0completes=C2=A0and=C2=A0the
>>=C2=A0>new=C2=A0drive=C2=A0takes=C2=A0over.
>>=C2=A0>
>>=C2=A0>This=C2=A0is=C2=A0because=C2=A0the=C2=A0replacement=C2=A0write=
s=C2=A0are=C2=A0only=C2=A0triggered=C2=A0when
>>=C2=A0>'s.replacing'=C2=A0is=C2=A0set=C2=A0and=C2=A0not=C2=A0when=C2=A0=
the=C2=A0similar=C2=A0's.sync'=C2=A0is=C2=A0set=C2=A0(which
>>=C2=A0>is=C2=A0the=C2=A0case=C2=A0during=C2=A0resync=C2=A0and=C2=A0re=
covery=C2=A0-=C2=A0it=C2=A0means=C2=A0all=C2=A0devices=C2=A0need=C2=A0t=
o
>>=C2=A0>be=C2=A0read).
>>=C2=A0>
>>=C2=A0>So=C2=A0schedule=C2=A0those=C2=A0writes=C2=A0when=C2=A0s.repla=
cing=C2=A0is=C2=A0set=C2=A0as=C2=A0well.
>>=C2=A0>
>>=C2=A0>In=C2=A0this=C2=A0case=C2=A0we=C2=A0cannot=C2=A0use=C2=A0"STRI=
PE_INSYNC"=C2=A0to=C2=A0record=C2=A0that=C2=A0the
>>=C2=A0>replacement=C2=A0has=C2=A0happened=C2=A0as=C2=A0that=C2=A0is=C2=
=A0needed=C2=A0for=C2=A0recording=C2=A0that=C2=A0any
>>=C2=A0>parity=C2=A0calculation=C2=A0is=C2=A0complete.=C2=A0=C2=A0So=C2=
=A0introduce=C2=A0STRIPE_REPLACED=C2=A0to
>>=C2=A0>record=C2=A0if=C2=A0the=C2=A0replacement=C2=A0has=C2=A0happene=
d.
>>=C2=A0>
>>=C2=A0>This=C2=A0bug=C2=A0was=C2=A0introduced=C2=A0in=C2=A0commit=C2=A0=
9a3e1101b827a59ac9036a672f5fa8d5279d0fe2
>>=C2=A0>(md/raid5:=C2=A0=C2=A0detect=C2=A0and=C2=A0handle=C2=A0replace=
ments=C2=A0during=C2=A0recovery.)
>>=C2=A0>which=C2=A0introduced=C2=A0replacement=C2=A0for=C2=A0raid5.
>>=C2=A0>That=C2=A0was=C2=A0in=C2=A03.3-rc3,=C2=A0so=C2=A0any=C2=A0stab=
le=C2=A0kernel=C2=A0since=C2=A0then=C2=A0would=C2=A0benefit
>>=C2=A0>from=C2=A0this=C2=A0fix.
>>=C2=A0>
>>=C2=A0>Cc:=C2=A0stable@vger.kernel.org=C2=A0(3.3+)
>>=C2=A0>Reported-by:=C2=A0qindehua=C2=A0<13691222965@163.com>
>>=C2=A0>Signed-off-by:=C2=A0NeilBrown=C2=A0<neilb@suse.de>
>>=C2=A0>
>>=C2=A0>diff=C2=A0--git=C2=A0a/drivers/md/raid5.c=C2=A0b/drivers/md/ra=
id5.c
>>=C2=A0>index=C2=A02bf094a..f0aa7abd=C2=A0100644
>>=C2=A0>---=C2=A0a/drivers/md/raid5.c
>>=C2=A0>+++=C2=A0b/drivers/md/raid5.c
>>=C2=A0>@@=C2=A0-3607,8=C2=A0+3607,8=C2=A0@@=C2=A0static=C2=A0void=C2=A0=
handle_stripe(struct=C2=A0stripe_head=C2=A0*sh)
>>=C2=A0>=C2=A0			handle_parity_checks5(conf,=C2=A0sh,=C2=A0&s,=C2=A0di=
sks);
>>=C2=A0>=C2=A0	}
>>=C2=A0>=C2=A0
>>=C2=A0>-	if=C2=A0(s.replacing=C2=A0&&=C2=A0s.locked=C2=A0=3D=3D=C2=A0=
0
>>=C2=A0>-	=C2=A0=C2=A0=C2=A0=C2=A0&&=C2=A0!test_bit(STRIPE_INSYNC,=C2=A0=
&sh->state))=C2=A0{
>>=C2=A0>+	if=C2=A0((s.replacing=C2=A0||=C2=A0s.syncing)=C2=A0&&=C2=A0s=
=2Elocked=C2=A0=3D=3D=C2=A00
>>=C2=A0>+	=C2=A0=C2=A0=C2=A0=C2=A0&&=C2=A0!test_bit(STRIPE_REPLACED,=C2=
=A0&sh->state))=C2=A0{
>>=C2=A0>=C2=A0		/*=C2=A0Write=C2=A0out=C2=A0to=C2=A0replacement=C2=A0d=
evices=C2=A0where=C2=A0possible=C2=A0*/
>>=C2=A0>=C2=A0		for=C2=A0(i=C2=A0=3D=C2=A00;=C2=A0i=C2=A0<=C2=A0conf->=
raid_disks;=C2=A0i++)
>>=C2=A0>=C2=A0			if=C2=A0(test_bit(R5_UPTODATE,=C2=A0&sh->dev[i].flags=
)=C2=A0&&
>>=C2=A0>@@=C2=A0-3617,7=C2=A0+3617,9=C2=A0@@=C2=A0static=C2=A0void=C2=A0=
handle_stripe(struct=C2=A0stripe_head=C2=A0*sh)
>>=C2=A0>=C2=A0				set_bit(R5_LOCKED,=C2=A0&sh->dev[i].flags);
>>=C2=A0>=C2=A0				s.locked++;
>>=C2=A0>=C2=A0			}
>>=C2=A0>-		set_bit(STRIPE_INSYNC,=C2=A0&sh->state);
>>=C2=A0>+		if=C2=A0(s.replacing)
>>=C2=A0>+			set_bit(STRIPE_INSYNC,=C2=A0&sh->state);
>>=C2=A0>+		set_bit(STRIPE_REPLACED,=C2=A0&sh->state);
>>=C2=A0>=C2=A0	}
>>=C2=A0>=C2=A0	if=C2=A0((s.syncing=C2=A0||=C2=A0s.replacing)=C2=A0&&=C2=
=A0s.locked=C2=A0=3D=3D=C2=A00=C2=A0&&
>>=C2=A0>=C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0test_bit(STRIPE_INSYNC,=C2=A0&s=
h->state))=C2=A0{
>>=C2=A0>diff=C2=A0--git=C2=A0a/drivers/md/raid5.h=C2=A0b/drivers/md/ra=
id5.h
>>=C2=A0>index=C2=A0b0b663b..70c4932=C2=A0100644
>>=C2=A0>---=C2=A0a/drivers/md/raid5.h
>>=C2=A0>+++=C2=A0b/drivers/md/raid5.h
>>=C2=A0>@@=C2=A0-306,6=C2=A0+306,7=C2=A0@@=C2=A0enum=C2=A0{
>>=C2=A0>=C2=A0	STRIPE_SYNC_REQUESTED,
>>=C2=A0>=C2=A0	STRIPE_SYNCING,
>>=C2=A0>=C2=A0	STRIPE_INSYNC,
>>=C2=A0>+	STRIPE_REPLACED,
>>=C2=A0>=C2=A0	STRIPE_PREREAD_ACTIVE,
>>=C2=A0>=C2=A0	STRIPE_DELAYED,
>>=C2=A0>=C2=A0	STRIPE_DEGRADED,
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
