From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sun, 8 Jun 2014 09:10:45 +0100
Message-ID: <BLU436-SMTP1535675BF98253D9B967F17982E0@phx.gbl>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
	 <20140607075140.277c0880@natsu>
	 <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>, Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

On Sat, 2014-06-07 at 18:52 -0600, Chris Murphy wrote:
> I wrote:
> > How can there still be pending bad sectors, and yet no error and LB=
A reported?
>=20
> So I started another -t long test. And it comes up with an LBA not pr=
eviously reported.
>=20
> # 1  Extended offline    Completed: read failure       60%      1214 =
        430234064
>=20
> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8
> dd: writing to =E2=80=98/dev/sda=E2=80=99: Input/output error
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 3.63342 s, 0.0 kB/s
>=20
> On this sector the technique fails.
>=20
> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8 oflag=3D=
direct
> 8+0 records in
> 8+0 records out
> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s

I may be missing something here, but surely after all this faffing abou=
t
and errors isn't it about time to replicate the data to a new drive and
then hit this one repeatedly with a very large hammer.

The law of diminishing returns must surely be coming into play by now.

>=20
> This technique works.
>=20
> However, this seems like a contradiction. A complete -t long results =
in:
>=20
> # 1  Extended offline    Completed without error       00%      1219 =
        -
>=20
> and yet
>=20
> 197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Alw=
ays       -       16
>=20
> How are there 16 pending sectors, with no errors found during the ext=
ended offline test? In order to fix this without SMART reporting the af=
fected LBAs, I'd have to write to every sector on the drive. This seems=
 like bad design or implementation.
>=20
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
