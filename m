From: "Majed B." <majedb@gmail.com>
Subject: Re: Slow network speeds between Linux RAID box and Windows PC
Date: Wed, 30 Sep 2009 07:12:23 +0300
Message-ID: <70ed7c3e0909292112h3587a4adyd96b8b26fed83f50@mail.gmail.com>
References: <3513de790909292020k79f6b83blf62e73aeb91d4681@mail.gmail.com>
	<3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you run: ethtool ethx (x is your ethernet's port number)
What does the Speed line say? 100Mbps or 1000Mbps?

I experienced some weird slowness from Vista only (Didn't have Win7
but I'd expect it to behave similarly), but never from XP. After some
search at that time, turns out it was Vista's fault, but Samba had a
workaround, which unfortunately I can't remember.

Try booting into Windows XP, or a Linux LiveCD on your other machine
and see if you still get slowness in transfers.

On Wed, Sep 30, 2009 at 6:22 AM, Dylan Distasio <interzone@gmail.com> w=
rote:
> I apologize that this question is not directly related to mdadm, but =
I
> thought some of the list might have experience in a mixed
> Linux/Windows environment. =C2=A0I am running a mdadm RAID5 file serv=
er on
> a Ubuntu 8.04 Linux box on a gigabit LAN. =C2=A0I am using a Highpoin=
t 2680
> card at PCI-E 4x as the controller (I have also tried the motherboard
> SATA connectors directly). =C2=A0I am running SAMBA on this box to sh=
are my
> RAID5 with my main Windows PC running Windows 7 64 bit (although I
> have gotten similar results with Vista also).
> My question is related to what I consider slow speeds when reading
> from or writing to the array from my Windows box. =C2=A0I get anywher=
e from
> 20-30MB/s in either direction when transferring a single large file (=
3
> GB as an example). =C2=A0I haven't done detailed benchmarking on the =
array,
> but spotchecks of file transfers from another drive on the same linux
> box are giving me speeds above 100MB/s for reads and writes.
> Does anyone have any suggestions for improving my speeds across the
> network? =C2=A0I don't know if SAMBA is causing some kind of bottlene=
ck or
> if Windows is not playing nice or if it's something with my network
> configuration, but I was hoping to get alot closer to saturating the
> gigabit connection. =C2=A0Any help would be greatly appreciated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
