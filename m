From: =?ISO-8859-1?Q?Geir_R=E5ness?= <post@pulz.no>
Subject: Re: Really fucked up raid0 array
Date: Mon, 05 Jul 2004 17:02:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E96D69.40705@pulz.no>
References: <40E93DFC.6070507@pulz.no> <200407051658.02492.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407051658.02492.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten van den Berg wrote:

>On Monday 05 July 2004 13:39, Geir R=E5ness wrote:
> =20
>
>>Hi
>>
>>When i woke up this morning i noticed my ps aux shuddenly stop during
>>listning proccess, and refuses to abort or complete it self.
>>So i started to worry that something is wrong, i noticed in dmesg tha=
t
>>one of my sw raid arrays had got errors during the night.
>>
>>hdn: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
>>hdn: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D5100103=
2,
>>high=3D3, low=3D669384, sector=3D51001032
>>end_request: I/O error, dev 58:40 (hdn), sector 51001032
>>
>>So i try to unmount the device with the unmount -f /some/fuckedArray,
>>but it refuses to let me unmount it.
>>   =20
>>
>
>Maybe you cannot umount it because it's still in use ?  In that case, =
run=20
>'lsof | grep <mountpoint>' to see what resources use files on that mou=
ntpoint,=20
>and terminate these processes first.
>
>Maarten
>
> =20
>
Way ahead of you.
lsof freeses to, so i arn't able to find out what is using the disk.

All programs like:
ps
w
finger
who
lsof
ls

and stuff like that freeses

I also tried killing prorgrams that might be in the danger sone of usin=
g=20
the disk, killall -9 blahblah
and it freeses :)


Best Regards
Geir R=E5ness
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
