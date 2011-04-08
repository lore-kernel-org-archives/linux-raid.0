From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What the heck happened to my array?
Date: Fri, 8 Apr 2011 12:27:55 -0300
Message-ID: <BANLkTinJ+VqEf0Se8Wj_8J08W0ofsShVWQ@mail.gmail.com>
References: <4D9876E4.6080501@fnarfbargle.com>
	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
	<4D995E27.3060800@fnarfbargle.com>
	<BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
	<4D9A6694.4040606@fnarfbargle.com>
	<20110405161043.00d54901@notabene.brown>
	<4D9E6285.8000006@fnarfbargle.com>
	<20110408195238.1e051c40@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408195238.1e051c40@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi neil, with time i could help changin sysfs information (add unit
information at output, and remove it (unit text) from input)
what's the current kernel version of develop?

2011/4/8 NeilBrown <neilb@suse.de>:
> On Fri, 08 Apr 2011 09:19:01 +0800 Brad Campbell <lists2009@fnarfbarg=
le.com>
> wrote:
>
>> On 05/04/11 14:10, NeilBrown wrote:
>>
>> > I would suggest:
>> > =A0 =A0copy anything that you need off, just in case - if you can.
>> >
>> > =A0 =A0Kill the mdadm that is running in the back ground. =A0This =
will mean that
>> > =A0 =A0if the machine crashes your array will be corrupted, but yo=
u are thinking
>> > =A0 =A0of rebuilding it any, so that isn't the end of the world.
>> > =A0 =A0In /sys/block/md0/md
>> > =A0 =A0 =A0 cat suspend_hi> =A0suspend_lo
>> > =A0 =A0 =A0 cat component_size> =A0sync_max
>> >
>>
>> root@srv:/sys/block/md0/md# cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md0 : active raid6 sdc[0] sdd[6](S) sdl[1](S) sdh[9] sda[8] sde[7]
>> sdg[5] sdb[4] sdf[3] sdm[2]
>> =A0 =A0 =A0 =A07814078464 blocks super 1.2 level 6, 512k chunk, algo=
rithm 2
>> [10/8] [U_UUUU_UUU]
>> =A0 =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>=
=2E..] =A0reshape =3D 88.2% (861696000/976759808)
>> finish=3D3713.3min speed=3D516K/sec
>>
>> md2 : active raid5 sdi[0] sdk[3] sdj[1]
>> =A0 =A0 =A0 =A01465146368 blocks super 1.2 level 5, 64k chunk, algor=
ithm 2 [3/3]
>> [UUU]
>>
>> md6 : active raid1 sdp6[0] sdo6[1]
>> =A0 =A0 =A0 =A0821539904 blocks [2/2] [UU]
>>
>> md5 : active raid1 sdp5[0] sdo5[1]
>> =A0 =A0 =A0 =A0104864192 blocks [2/2] [UU]
>>
>> md4 : active raid1 sdp3[0] sdo3[1]
>> =A0 =A0 =A0 =A020980800 blocks [2/2] [UU]
>>
>> md3 : active raid1 sdp2[0] sdo2[1]
>> =A0 =A0 =A0 =A08393856 blocks [2/2] [UU]
>>
>> md1 : active raid1 sdp1[0] sdo1[1]
>> =A0 =A0 =A0 =A020980736 blocks [2/2] [UU]
>>
>> unused devices: <none>
>> root@srv:/sys/block/md0/md# cat component_size > sync_max
>> cat: write error: Device or resource busy
>
> Sorry, I should have checked the source code.
>
>
> =A0 echo max > sync_max
>
> is what you want.
> Or just a much bigger number.
>
>>
>> root@srv:/sys/block/md0/md# cat suspend_hi suspend_lo
>> 13788774400
>> 13788774400
>
> They are the same so that is good - nothing will be suspended.
>
>>
>> root@srv:/sys/block/md0/md# grep . sync_*
>> sync_action:reshape
>> sync_completed:1723392000 / 1953519616
>> sync_force_parallel:0
>> sync_max:1723392000
>> sync_min:0
>> sync_speed:281
>> sync_speed_max:200000 (system)
>> sync_speed_min:200000 (local)
>>
>> So I killed mdadm, then did the cat suspend_hi > suspend_lo.. but as=
 you
>> can see it won't let me change sync_max. The array above reports
>> 516K/sec, but that was just on its way down to 0 on a time based
>> average. It was not moving at all.
>>
>> I then tried stopping the array, restarting it with mdadm 3.1.4 whic=
h
>> immediately segfaulted and left the array in state resync=3DDELAYED.
>>
>> I issued the above commands again, which succeeded this time but whi=
le
>> the array looked good, it was not resyncing :
>> root@srv:/sys/block/md0/md# cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4]
>> md0 : active raid6 sdc[0] sdd[6](S) sdl[1](S) sdh[9] sda[8] sde[7]
>> sdg[5] sdb[4] sdf[3] sdm[2]
>> =A0 =A0 =A0 =A07814078464 blocks super 1.2 level 6, 512k chunk, algo=
rithm 2
>> [10/8] [U_UUUU_UUU]
>> =A0 =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>=
=2E..] =A0reshape =3D 88.2% (861698048/976759808)
>> finish=3D30203712.0min speed=3D0K/sec
>>
>> md2 : active raid5 sdi[0] sdk[3] sdj[1]
>> =A0 =A0 =A0 =A01465146368 blocks super 1.2 level 5, 64k chunk, algor=
ithm 2 [3/3]
>> [UUU]
>>
>> md6 : active raid1 sdp6[0] sdo6[1]
>> =A0 =A0 =A0 =A0821539904 blocks [2/2] [UU]
>>
>> md5 : active raid1 sdp5[0] sdo5[1]
>> =A0 =A0 =A0 =A0104864192 blocks [2/2] [UU]
>>
>> md4 : active raid1 sdp3[0] sdo3[1]
>> =A0 =A0 =A0 =A020980800 blocks [2/2] [UU]
>>
>> md3 : active raid1 sdp2[0] sdo2[1]
>> =A0 =A0 =A0 =A08393856 blocks [2/2] [UU]
>>
>> md1 : active raid1 sdp1[0] sdo1[1]
>> =A0 =A0 =A0 =A020980736 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
>> root@srv:/sys/block/md0/md# grep . sync*
>> sync_action:reshape
>> sync_completed:1723396096 / 1953519616
>> sync_force_parallel:0
>> sync_max:976759808
>> sync_min:0
>> sync_speed:0
>> sync_speed_max:200000 (system)
>> sync_speed_min:200000 (local)
>>
>> I stopped the array and restarted it with mdadm 3.2.1 and it continu=
ed
>> along its merry way.
>>
>> Not an issue, and I don't much care if it blew something up, but I
>> thought it worthy of a follow up.
>>
>> If there is anything you need tested while it's in this state I've g=
ot ~
>> 1000 minutes of resync time left and I'm happy to damage it if reque=
sted.
>
> No thank - I think I know what happened. =A0Main problem is that ther=
e is
> confusion between 'k' and 'sectors' and there are random other values=
 that
> sometimes work (like 'max') and I never remember which is which. =A0s=
ysfs in md
> is a bit of a mess.... one day I hope to completely replace it (with =
back
> compatibility of course...)
>
> Thanks for the feedback.
>
> NeilBrown
>
>
>>
>> Regards,
>> Brad
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
