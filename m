From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Raid 6--best practices
Date: Fri, 20 Jan 2012 03:06:19 +0000
Message-ID: <CADNH=7Fb5tV+_z4eeOW0K8X+FVtUnaKxtT04qBSh_WQNT+kTDg@mail.gmail.com>
References: <4F173D3D.6070902@npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shain Miley <SMiley@npr.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20 January 2012 02:54, Shain Miley <SMiley@npr.org> wrote:
> Hello all,
> I have been doing some research into possible alternatives to our
> OpenSolaris/ZFS/Gluster file server. =C2=A0The main reason behind thi=
s is,
> due to RedHat's recent purchase of Gluster, our current configuration
> will no longer be supported and even before the acquisition, the upgr=
ade
> path for the OpenSolaris/ZFS stack was murky at best.
>
> The current servers in question consist of a total of 48, 2TB drives.
> My thought was that I would setup a total of 6 RAID-6 arrays (each
> containing 7 drives + a spare or a flat 8 drive RAID-6 config) and pl=
ace
> LVM + XFS on top of that.
>
> My questions really are:
>
> a) =C2=A0 =C2=A0What is the maximum number of drives typically seen i=
n a RAID-6
> setup like this? =C2=A0I noticed when looking at the Backblaze blog, =
that
> they are using RAID-6 with 15 disks (13 + 2 for parity). =C2=A0That n=
umber seemed
> kind of high to me....but I was wondering what others on the list tho=
ught.
>
> b) =C2=A0 =C2=A0Would you recommend using any specific Linux distro o=
ver any other?
> Right now I am trying to decide between Debian and Ubuntu....but I wo=
uld be open to
> any others...if there was a legitimate reason to do so (performance, =
stability, etc) in terms of the Raid codebase.
>
> Thanks in advance,
>
> Shain
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml


Hi,

Personally I wouldn't use more than 10 HDDs in a RAID6 setup (+ spare
perhaps). Regarding the choice of distribution, it doesn't matter
really. Pick the one you're comfortable with.

Good luck!

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
