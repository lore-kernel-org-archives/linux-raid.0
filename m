From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Really fucked up raid0 array
Date: Mon, 5 Jul 2004 16:58:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407051658.02492.maarten@ultratux.net>
References: <40E93DFC.6070507@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E93DFC.6070507@pulz.no>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 05 July 2004 13:39, Geir R=E5ness wrote:
> Hi
>
> When i woke up this morning i noticed my ps aux shuddenly stop during
> listning proccess, and refuses to abort or complete it self.
> So i started to worry that something is wrong, i noticed in dmesg tha=
t
> one of my sw raid arrays had got errors during the night.
>
> hdn: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hdn: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D5100103=
2,
> high=3D3, low=3D669384, sector=3D51001032
> end_request: I/O error, dev 58:40 (hdn), sector 51001032
>
> So i try to unmount the device with the unmount -f /some/fuckedArray,
> but it refuses to let me unmount it.

Maybe you cannot umount it because it's still in use ?  In that case, r=
un=20
'lsof | grep <mountpoint>' to see what resources use files on that moun=
tpoint,=20
and terminate these processes first.

Maarten

--=20
When I answered where I wanted to go today, they just hung up -- Unknow=
n

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
