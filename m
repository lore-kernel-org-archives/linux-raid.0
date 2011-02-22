From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Tue, 22 Feb 2011 17:12:39 +0000
Message-ID: <AANLkTikcDiKp_iPxaP9Ke231Rnb-wOgJP3owXUVxnkSD@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
	<4D5C4176.80604@gmail.com>
	<4D5C4204.5020106@turmel.org>
	<1377706586882297883@unknownmsgid>
	<4D5C6016.6060809@turmel.org>
	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>
	<4D5D2723.1010101@turmel.org>
	<6037962689649361915@unknownmsgid>
	<AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gmail.com>
	<4D5D52AE.8070602@turmel.org>
	<AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>
	<4D5FE208.5020700@turmel.org>
	<AANLkTinOXJWRw_et2U43R_T9XPBzQLnN56Kf2bOAz=_c@mail.gmail.com>
	<4D5FED98.6060407@turmel.org>
	<AANLkTin4u9yk4XPiHzFtagrdV5_iZJZ0+P+yHqH0x9bm@mail.gmail.com>
	<4D61707D.4040304@turmel.org>
	<AANLkTimL5y_-RPB9KvTM_N_kMojO6v94PNKjeC+4C=T5@mail.gmail.com>
	<4D61A64B.6090708@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D61A64B.6090708@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,
I thought it was fixed, but every time I do a reboot it disappears
again.  I did the:
pvcreate --restorefile 'simons-lvm-backup' --uuid
9fAJEz-HcaP-RQ51-fV8b-nxrN-Uqwb-PPnOLJ /dev/md0 and the vgcfgrestore

the only piece of your advice that I didn't follow was "zero the
superblock on the removed drive" as I thought re-adding it to the
array would do that anyway.  Did this cause me problems ?

proxmox:~# mdadm  --assemble --scan -v
mdadm: looking for devices for /dev/md/0
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: /dev/dm-1 has wrong uuid.
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: /dev/dm-0 has wrong uuid.
mdadm: /dev/sdo1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdo
mdadm: /dev/sdo has wrong uuid.
mdadm: /dev/sdn1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdn
mdadm: /dev/sdn has wrong uuid.
mdadm: /dev/sdm1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdm
mdadm: /dev/sdm has wrong uuid.
mdadm: /dev/sdl1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdl
mdadm: /dev/sdl has wrong uuid.
mdadm: /dev/sdk1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk
mdadm: /dev/sdk has wrong uuid.
mdadm: /dev/sdj1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: /dev/sdi1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdi
mdadm: /dev/sdi has wrong uuid.
mdadm: /dev/sdh1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: /dev/sdf1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.

I'm getting frustrated now.  It seems like it's fixzed, then next
reboot, BAM, it's gone again.  I'm so out of my depth here.

Please can you help me fix this once and for all ?

cheers
Simon

On 20 February 2011 23:39, Phil Turmel <philip@turmel.org> wrote:
> On 02/20/2011 06:17 PM, Simon Mcnair wrote:
>> Phil,
>> You are a god amongst men :-)
>
> Heh. =A0I read that out loud to my wife....
>
>> I seem to have the vast majority of my data. =A0I can't see anything=
 in
>> lost+found and the fsck log doesn't list any filenames etc of missin=
g
>> data. =A0Is there any way for me to find anything that I've lost ?
>
> Not that I know of, short of a list of names from before the crash.
>
> Glad to hear that the family treasures are safe.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
