From: Luca Berra <bluca@comedia.it>
Subject: Re: How to load preexisting ntfs partitions that are on an Intel
	Matrix Raid 1 or 5 ?
Date: Sat, 16 Jan 2010 10:08:49 +0100
Message-ID: <20100116090848.GA21855@maude.comedia.it>
References: <8CC636345AA2F7E-295C-545@webmail-d049.sysops.aol.com> <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ataraid-list@redhat.com
List-Id: linux-raid.ids

On Thu, Jan 14, 2010 at 03:09:22PM -0500, sylarrrrrrr@aim.com wrote:
>  How to load preexisting ntfs partitions that are on an Intel Matrix =
Raid 1=20
> or 5 ?

either with md or dmraid + ntfs-3g

> I must also know that the loading of the partitions in linux will not=
=20
> damage them.
> Is the Intel Matrix Raid feature safe ?
which one?
dmraid i have no info, just tried it once,
mdadm: check the archives of this list
3.0.2 is broken
3.0.3 fixes some bugs
many more bug fixes are in git and will be in 3.1.2 i believe.

> I tried with the latest Knoppix 6.2 LiveCD, but the device was not=20
> seenautomatically,=A0 in /dev/mapper I found too many entries, which =
made=20
> mesuspicious that my raids are not recognized well.

/dev/mapper is dmraid not mdadm,
besides that what do you mean with two many?
show evidence (dmsetup ls, dmraid -c, etc)
and maybe send it to ataraid-list@redhat.com, which deals with dmraid
> Packages versions in my Knoppix:
>
> ii  mdadm                                  3.0.3-2                   =
      =20
>  tool to administer Linux MD arrays (software
>
> ii  linux-image-2.6.31.6                   2.6.31.6-10.00.Custom     =
      =20
>  Linux kernel binary image for version 2.6.31
>
>
>

--=20
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
