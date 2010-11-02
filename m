From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: status of sas1068 ata-passthrough bug?
Date: Tue, 2 Nov 2010 22:05:17 +0000
Message-ID: <20101102220517.41416adb.ctpm@ist.utl.pt>
References: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mon, 1 Nov 2010 17:08:38 -0500 Matt Garman <matthew.garman@gmail.com=
> wrote:
> I've seen a few mentions on this list of kernel bug 14831 / 13594,
> where drives on an LSI SAS1068 controller are dropped when smartd is
> run:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D14831
> https://bugzilla.kernel.org/show_bug.cgi?id=3D13594
>=20
> I was just wondering if this bug is "officially" fixed, and if so, in
> what kernel version?  The Bugzilla entries above don't show it as
> fixed, but I saw on this list someone mentioned that it's fixed in
> 2.6.36 (I think---I can't find that post now).
>=20

 Hi,

 This is indeed fixed in v2.6.36, by commit 2a1b7e5

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D2a1b7e5

 I've been running a 16-disk RAID6 MD array since 2.6.36 and I can use
smartmontools with no issues.

 Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
