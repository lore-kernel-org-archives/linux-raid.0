From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Tue, 22 Feb 2011 13:23:27 -0500
Message-ID: <4D63FF1F.4030201@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<4D5C4176.80604@gmail.com>	<4D5C4204.5020106@turmel.org>	<1377706586882297883@unknownmsgid>	<4D5C6016.6060809@turmel.org>	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>	<4D5D2723.1010101@turmel.org>	<6037962689649361915@unknownmsgid>	<AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gmail.com>	<4D5D52AE.8070602@turmel.org>	<AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>	<4D5FE208.5020700@turmel.org>	<AANLkTinOXJWRw_et2U43R_T9XPBzQLnN56Kf2bOAz=_c@mail.gmail.com>	<4D5FED98.6060407@turmel.org>	<AANLkTin4u9yk4XPiHzFtagrdV5_iZJZ0+P+yHqH0x9bm@mail.gmail.com>	<4D61707D.4040304@turmel.org>	<AANLkTimL5y_-RPB9KvTM_N_kMojO6v94PNKjeC+4C=T5@m
 ail.gmail.com>	<4D61A64B.6090708@turmel.org>	<AANLkTikcDiKp_iPxaP9Ke231Rnb-wOgJP3owXUVxnkSD@mail.gmail.com> <AANLkTimDnfjqC=gUiUb2qshXOMeR_zKK8M55tOGmP+V-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimDnfjqC=gUiUb2qshXOMeR_zKK8M55tOGmP+V-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/22/2011 12:14 PM, Simon Mcnair wrote:
> was this anything to do with the dist-upgrade that I performed ?
> 
> mdadm has upgraded again to
> proxmox:~# mdadm -V
> mdadm - v3.1.4 - 31st August 2010

No, but you probably can't do any more "--create --assume-clean" operations with that array.

As for the assembly errors, its probably an out-of-date mdadm.conf.

My server's looks like this:

> DEVICE /dev/sd[a-z][1-9]
> 
> ARRAY /dev/md23 UUID=c3cbe096:fc43d939:8aa66230:708c5670
> ARRAY /dev/md22 UUID=1438a239:aa03c3f9:68e051d7:b59a6219
> ARRAY /dev/md21 UUID=4b47d0f6:16f0e352:c67a2185:feb0b573
> ARRAY /dev/md20 UUID=7676c77e:6ae70f65:30a170a2:b1a1b242

Yours probably needs to be updated with the new md0 uuid.  Its not your boot drive, so your initramfs shouldn't matter.

Phil
