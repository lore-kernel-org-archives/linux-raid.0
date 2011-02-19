From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Sat, 19 Feb 2011 08:43:12 +0000
Message-ID: <AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D52AE.8070602@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,
Sorry for the spamming, but I'm just keeping you informed :-).

proxmox:/home/simon# ./block2gz.sh sdd /media/ntfs3g/sdb
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 95384 s, 10.5 MB/s

proxmox:/home/simon# ./block2gz.sh sde /media/ntfs3g/sdn
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 106317 s, 9.4 MB/s

proxmox:/home/simon# ./block2gz.sh sdf /media/ntfs3g/sdc
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 104711 s, 9.6 MB/s

proxmox:/home/simon# ./block2gz.sh sdg /media/ntfs3g/sdb
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 104980 s, 9.5 MB/s

proxmox:/home/simon# ./block2gz.sh sdh /media/ntfs3g/sdn
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 98105.1 s, 10.2 MB/s

proxmox:/home/simon# ./block2gz.sh sdi /media/ntfs3g/sdc
953869+1 records in
953869+1 records out
1000204886016 bytes (1.0 TB) copied, 98291 s, 10.2 MB/s
proxmox:/home/simon#

Have just started sdj,sdk,sdl,sdm.  I was thinking of renaming the
=2Egz's with the serial number as this would seem to me as more useful,
is this a good idea ?

These numbers are not at all reflective of the drive or controller
speed as I took the lazy route and was writing 2 sets of images at the
same time to the same drive and in addition gzip was also running
(although not really stressing the system from what I could tell).

I suspect also that the drives may be pretty fragmented as the space
was not allocated at the start of the write, so that may have had some
impact too.

Simon

On 17 February 2011 16:54, Phil Turmel <philip@turmel.org> wrote:
> On 02/17/2011 09:34 AM, Simon Mcnair wrote:
>> 19390 root =A0 =A0 =A0 17.49 M/s =A0 =A0 =A0 0 B/s =A00.00 % 21.36 %=
 dd if /dev/sde bs 1M
>> 19333 root =A0 =A0 =A0 16.52 M/s =A0 =A0 =A0 0 B/s =A00.00 % 17.07 %=
 dd if /dev/sdd bs 1M
>> 19503 root =A0 =A0 =A0 15.79 M/s =A0 =A0 =A0 0 B/s =A00.00 % 13.91 %=
 dd if /dev/sdf bs 1M
>> 18896 root =A0 =A0 =A0 =A0 =A0 0 B/s =A0 16.10 M/s =A00.00 % =A00.00=
 % ntfs-3g
>> /dev/sdb1 /media/ntfs3g/sdb
>> 18909 root =A0 =A0 =A0 =A0 =A0 0 B/s =A0 13.49 M/s =A00.00 % =A00.00=
 % ntfs-3g
>> /dev/sdc1 /media/ntfs3g/sdc
>> 18920 root =A0 =A0 =A0 =A0 =A0 0 B/s =A0 15.73 M/s =A00.00 % =A00.00=
 % ntfs-3g
>> /dev/sdn1 /media/ntfs3g/sdn
>>
>> this will certainly be quicker :-)
>
> But still a long time...
>
> Let me know.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
