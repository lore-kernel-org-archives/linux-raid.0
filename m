From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Sat, 19 Feb 2011 10:30:16 -0500
Message-ID: <4D5FE208.5020700@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<4D5C4176.80604@gmail.com>	<4D5C4204.5020106@turmel.org>	<1377706586882297883@unknownmsgid>	<4D5C6016.6060809@turmel.org>	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>	<4D5D2723.1010101@turmel.org>	<6037962689649361915@unknownmsgid>	<AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gm
 ail.com>	<4D5D52AE.8070602@turmel.org> <AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/19/2011 03:43 AM, Simon Mcnair wrote:
> Phil,
> Sorry for the spamming, but I'm just keeping you informed :-).
> 
> proxmox:/home/simon# ./block2gz.sh sdd /media/ntfs3g/sdb
> 953869+1 records in
> 953869+1 records out
> 1000204886016 bytes (1.0 TB) copied, 95384 s, 10.5 MB/s

[trim /]

> Have just started sdj,sdk,sdl,sdm.  I was thinking of renaming the
> .gz's with the serial number as this would seem to me as more useful,
> is this a good idea ?

Yes.  I guess they'll finish some time tomorrow?

> These numbers are not at all reflective of the drive or controller
> speed as I took the lazy route and was writing 2 sets of images at the
> same time to the same drive and in addition gzip was also running
> (although not really stressing the system from what I could tell).

The CPU was busy, but not overloaded.  The per-drive data rates were 1/5th to 1/10th what I would have expected.  The Asus P6T SE motherboard has a lot of bandwidth.  Something's odd.

Can you attach a copy of your dmesg?

> I suspect also that the drives may be pretty fragmented as the space
> was not allocated at the start of the write, so that may have had some
> impact too.

Ntfs-3g can push 70+ MB/s onto my heavily fragged Windows laptop partition with only 50% of a Core2 Duo.  I doubt that's it.

Phil
