From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: LVM on raid10,f2 performance issues
Date: Wed, 3 Dec 2008 08:15:04 +0100
Message-ID: <20081203071504.GA8161@rap.rap.dk>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4935C4B3.2060404@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Mauermann <mauermann@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 03, 2008 at 12:28:51AM +0100, Holger Mauermann wrote:
> Keld J=F8rn Simonsen schrieb:
> > How is it if you use the raid10,f2 without lvm?
> > What are the numbers?
>=20
> After a fresh installation LVM performance is now somewhat better. I
> don't know what was wrong before. However, it is still not as fast as
> the raid10...
>=20
> dd on raw devices
> -----------------
>=20
> raid10,f2:
>   read : 409 MB/s
>   write: 212 MB/s
>=20
> raid10,f2 + lvm:
>   read : 249 MB/s
>   write: 158 MB/s


What is the performance with raid0?

What is the performance with a filesystem?

Did you try=20

blockdev --setra 65536 /dev/md3

How many disks are you using?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
