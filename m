From: Henti Smith <henti@geekware.co.za>
Subject: Re: additional feature for linear
Date: Sat, 17 Sep 2011 17:32:39 +0200
Message-ID: <CAC_HdUrFADb1G-5cos4foKohv8B=B0-pA=O8nbGnSX4z7mWcKg@mail.gmail.com>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
	<6385457414268580907@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6385457414268580907@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Sep 17, 2011 at 5:20 PM, J=E9r=F4me Poulin <jeromepoulin@gmail.=
com> wrote:
> On 2011-09-17, at 03:14, Henti Smith <henti@geekware.co.za> wrote:
>
>> Would it not be possible to add functions to linear mode to mark thi=
s
>> missing chunks as "bad blacks" and let the FS deal with it as such.
>
> Linux RAID can already deal with such a problem IIRC but if the
> filesystem superblock is missing or directory entries, you ain't goin=
g
> no where. This kind of feature would require filesystem knowledge of
> where the RAID split the device and would be better suited to a FS
> like BTRFS which mirror superblock and metadata without any Linux
> RAID.

Hi J=E9r=F4me

Thanks for the reply. I though BTRFS would be a good option as well,
but they don't seem to understand what I'm looking for :)

I have found a fuse base FS that seems to do this, so will play with th=
at.

It's called http://romanrm.ru/en/mhddfs and seems to do what I need it
to do so will test :)

Thanks again for replying.

Henti
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
