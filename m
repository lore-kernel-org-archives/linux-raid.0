From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: status of sas1068 ata-passthrough bug?
Date: Tue, 2 Nov 2010 22:00:43 -0500
Message-ID: <AANLkTi=m0QSBq=W0KoZiSo_5hdbi31z9ipV2z6s5C2=T@mail.gmail.com>
References: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
	<20101102220517.41416adb.ctpm@ist.utl.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101102220517.41416adb.ctpm@ist.utl.pt>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Cl=E1udio_Martins?= <ctpm@ist.utl.pt>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2010/11/2 Cl=E1udio Martins <ctpm@ist.utl.pt>:
> On Mon, 1 Nov 2010 17:08:38 -0500 Matt Garman <matthew.garman@gmail.c=
om> wrote:
>> I've seen a few mentions on this list of kernel bug 14831 / 13594,
>> where drives on an LSI SAS1068 controller are dropped when smartd is
>> run:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D14831
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D13594
>>
>> I was just wondering if this bug is "officially" fixed, and if so, i=
n
>> what kernel version? =A0The Bugzilla entries above don't show it as
>> fixed, but I saw on this list someone mentioned that it's fixed in
>> 2.6.36 (I think---I can't find that post now).
>>
>
> =A0Hi,
>
> =A0This is indeed fixed in v2.6.36, by commit 2a1b7e5
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D2a1b7e5
>
> =A0I've been running a 16-disk RAID6 MD array since 2.6.36 and I can =
use
> smartmontools with no issues.

Thank you, that is very helpful!

Do you, or the list in general, happen to know if this fix has made it
into any distribution-specific kernels?  E.g., ubuntu server, centos,
etc?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
