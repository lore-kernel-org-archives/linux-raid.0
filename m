From: =?UTF-8?B?V2llcmRsIE3DoXTDqQ==?= <wierdlmate@gmail.com>
Subject: Re: superblock error after power failure ---on an old system
Date: Sat, 24 Apr 2010 08:42:35 -0500
Message-ID: <g2u4dfc23d1004240642j8635863dpd176af38a0e64088@mail.gmail.com>
References: <h2g4dfc23d1004240409s2409f02i2b99c50473ae4301@mail.gmail.com>
	<i2z4dfc23d1004240418k4fb43ed6q10a3624ae9fb008@mail.gmail.com>
	<20100424214744.284ccadc@notabene.brown> <i2h4dfc23d1004240608i16872c26i1a13c489d69ee0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <i2h4dfc23d1004240608i16872c26i1a13c489d69ee0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Well, I now get, after rebooting:
>
> /dev/md3: UNEXPECTED INCONSISTENCY; run fsck manually
>
> So I did
>
> fsck -y /dev/md3
>
> and after running for about a minute or so, it gets into this
>
> Too many illegal blocks in inode 8
>
> and
>
> Illegal block #6828 (39485860) in inode 8. CLEARED
>
> Several lines of these, and then again
>
> Too many illegal blocks in inode 8
>
> The block number (#6828) changes but this loop never seems to end. I
> aborted this, for now. =C2=A0When I tried
>
> mount /dev/md3 /home
>
> I got: wrong fs type, bad option, bad superblock on md3
>
I ran fsck on /dev/md0 again, answered 'n' to the question if I wanted
to clear inode 8, and it gets into the following infinite loop

Directory inode 83161, block 0, offset 0: directory corrupted.
Salvage<y>?

If I answer 'y' then it asks the very same thing about inode 83161,
and if I answer n, then I get

e2fsck aborted.

M=C3=A1t=C3=A9




--=20
Matyi
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
