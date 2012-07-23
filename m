From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Mon, 23 Jul 2012 18:42:45 -0300
Message-ID: <CABYL=TrrQdtfg3gFiXL4Y9QoT9gzNNGnoGUcMN+sxKOH8kGvYQ@mail.gmail.com>
References: <500CD32E.4000800@hardwarefreak.com>
	<542194327.593466.1343036057599.JavaMail.root@redhat.com>
	<20120723170320.GA2691@lazy.lzy>
	<CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
	<CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

that=B4s the point...
in few words....

2012/7/23 Drew <drew.kay@gmail.com>:
> Been mulling this problem over and I keep getting hung up on one
> problem with ECC on a two disk RAID1 setup.
>
> In the event of silent corruption of one disk, which one is the good =
copy?
>
> It works fine if the ECC code is identical across both mirrors. Just
> checksum both chunks and discard the incorrect one.
nice we can recover data =3D)

>
> It also works fine if the ECC codes are corrupted but the data chunks
> are identical. Discard the bad checksum.
nice we can recover data too =3D)

>
> What if the corruption goes across several sectors and both data & EC=
C
> chuncks are corrupted? Now you're back to square one.
report badblock to upper layer (file system or a mdraid or lvm or
anyother process)
the same should occur on harddisk with known corrupted data
but in this case we know that=B4s wrong and we can report it! =3D) that=
=B4s
the nice part!
very different from "silent data corruption" where no alert or warning
or error is reported, that=B4s the today bad part...
ok... you will tell about NEC report? they have this 'software
security' in firmware (i think we could make something similar)


> --
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
