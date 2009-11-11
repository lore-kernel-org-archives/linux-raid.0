From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: need help: corrupt files on one of my raids
Date: Wed, 11 Nov 2009 00:31:35 -0800
Message-ID: <4877c76c0911110031l761244f7u4d90aba72e4743@mail.gmail.com>
References: <4AF97388.5080907@langseid.no>
	 <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>
	 <4AF99159.4000800@langseid.no>
	 <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>
	 <4AF9CB19.7000803@langseid.no>
	 <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>
	 <4AF9D194.6000306@langseid.no>
	 <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com>
	 <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
	 <4AFA72B8.8010802@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFA72B8.8010802@langseid.no>
Sender: linux-raid-owner@vger.kernel.org
To: Arild Langseid <arild@langseid.no>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Besides the man-page documented issues with 0.90 superblocks is the
fact that they are stored at the -end- of the partition.  This is a
good thing for boot-loaders like grub, which would like read-only
access to partitions to look at file-systems and read data.

However at the same time it is a -VERY- bad thing, because each member
of that raid1 array looks like it's own file-system.  Think about what
happens when one copy of that file-system is changed and the other(s)
is(are) not.

If you're careful, or don't care about the data in that partition (the
data in /boot is generally very -nice- to have, but the system can be
recovered and that data regenerated in one form or another), then
using the 0.9 format (or 1.0 for that matter) superblock is perfectly
fine.  Yet at the same time it's so easy to forget to force a device
rebuild the next time the array is assembled, and to remember to check
if your recovery CD/etc happened to start the array before mounting
things, or if it got mounted without being part of the raid-1 set.

This is why I mentioned using 0.9 / 1.0 only for special cases like
/boot.  1.1 and 1.2 are "better" because they are both at the front of
the partition and make it look nothing like a file-system that can be
mounted until assembled in to a raid array.

On Wed, Nov 11, 2009 at 12:15 AM, Arild Langseid <arild@langseid.no> wr=
ote:
> Hi Michael:
>
> I still ran your advice and got this result:
>
> creator:~# mdadm =A0-D /dev/md1
> /dev/md1:
> =A0 =A0 =A0 =A0Version : 00.90
>
> Is it a big problem running version 0.9? I use the version of the too=
ls that
> comes with Debian - and as they are "some" conservative their version=
s lags
> some behind.
>
> I have now upgraded my Debian Etch to Debian Lenny and have this mdad=
m:
> creator:~# mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
>
> When I fix the firmware issues on my motherboard or buys a sepparate =
sata
> controller.... will the superblock be one of the version you suggests=
 when I
> create the raid again? If not is it that large problem and I should u=
pgrade
> my tools beyond what Debian provides?
>
> Best Regards,
> Arild
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
