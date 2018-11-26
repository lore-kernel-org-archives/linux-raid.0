From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: LVM RAID: task mdX_raid1:221 blocked for more than
	120 seconds
Date: Mon, 26 Nov 2018 12:40:40 +0100
Message-ID: <d33355bb-51aa-992d-2ab9-9ef2641a119b@redhat.com>
References: <90473b46-274c-55af-3887-f058f2cf05dd@gmail.com>
	<6dc75647-bec9-564d-23fa-aeb626678cf6@redhat.com>
	<45bbdff9-b88c-4533-8aa5-9976564ed2bf@gmail.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <45bbdff9-b88c-4533-8aa5-9976564ed2bf@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Cesare Leonardi <celeonar@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 26. 11. 18 v 12:31 Cesare Leonardi napsal(a):
> Resending, I erroneusly replied only to Zdenek, sorry.
> =

> =

> =

> I can provide details about this, that was filed by me:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D913119
> =

> It's about a desktop PC, with two SSD (Samsung 850 EVO) on which i build =
RAID1 =

> using LVM.
> # pvs
>  =A0 PV=A0=A0=A0=A0=A0=A0=A0=A0 VG=A0 Fmt=A0 Attr PSize=A0=A0=A0 PFree
>  =A0 /dev/sdb3=A0 vg0 lvm2 a--=A0 <250,00g 15,98g
>  =A0 /dev/sdc3=A0 vg0 lvm2 a--=A0 <250,00g 15,98g
> =

> # lvs
>  =A0 LV=A0=A0=A0 VG=A0 Attr=A0=A0=A0=A0=A0=A0 LSize=A0=A0 Pool Origin Dat=
a%=A0 Meta%=A0 Move Log Cpy%Sync =

> Convert
>  =A0 home=A0 vg0 rwi-aor--- 200,00g 100,00
>  =A0 root=A0 vg0 rwi-aor---=A0 30,00g 100,00
>  =A0 swap0 vg0 rwi-aor---=A0=A0 4,00g 100,00
> =

> It's a desktop PC using Debian unstable, so it's rebooted quite often due=
 to =

> frequent updates.

So you should probably start first with running latest available kernel - 4=
.19.

You also should collect 'dmesg' report

> The freezes happens during normal work, without any resizing or any =

> maintenance on LVM going on. Most of the time I noted the freeze while I =
was =

> using Thunderbird. But eventually they resolve by themself: I wait minute=
s and =


Aren't you running out-of-memory ?

Install some CPU/MEM monitoring service and watch out for problems
(AFAIK OOM doesn't really work on my machine - and often  FF + Thunderbird =

combo brings it to the state mouse barely moves and CPU spins in kswapd...)

> I've not noticed any corruption due to these freeze but often they are ve=
ry =

> long and very impacting. The only reliable workaround found was to reboot=
 with:
> scsi_mod.use_blk_mq=3D0 dm_mod.use_blk_mq=3D0

I doubt this have anything in common with this.

Regards

Zdenek

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
