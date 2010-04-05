From: Mark Knecht <markknecht@gmail.com>
Subject: Re: metadata and / and grub-static
Date: Mon, 5 Apr 2010 08:52:22 -0700
Message-ID: <q2v5bdc1c8b1004050852j98b4b91fne8dea1399892862f@mail.gmail.com>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
	 <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>
	 <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>
	 <4BB9F9E4.2060802@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB9F9E4.2060802@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 5, 2010 at 7:55 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 05/04/2010 15:15, Mark Knecht wrote:
>>
>> On Sun, Apr 4, 2010 at 7:26 PM, Leslie Rhorer <lrhorer@satx.rr.com> =
wrote:
>> <SNIP>
>>>>
>>>> Answering self - putting / on RAID1 only seems to work using
>>>> --metadata=3D0.90. Tried it with higher versions and had no luck.
>>>
>>> =C2=A0 =C2=A0 =C2=A0 One may most certainly run a RAID1 / or /boot =
(or both) using other
>>> than 0.9 metadata. =C2=A0I'm running two servers with / on a 1.02 s=
uperblock
>>> and
>>> /boot on a 1.0 superblock, booting with grub 0.97.
>>
>> Are you using an initrd? I could not make it work above 0.90 without
>> going that way which I didn't want to do.
>
> Yes, the kernel will only auto-assemble arrays with 0.90 metadata, an=
d Neil
> Brown has stated several times that there never will be support for
> auto-assembling anything else in the kernel.
>
> You can still have your /boot with 1.0 metadata using grub 0.97 (or e=
ven
> LILO) and your root with any metadata but you will need an initrd con=
taining
> mdadm with which to assemble your arrays before attempting to mount t=
he root
> filesystem.
>
> But if you're determined to avoid an initrd, you're stuck with 0.90 m=
etadata
> for your root filesystem. This probably isn't much of a limitation si=
nce you
> can still have a 27-drive RAID-6 array of 2TB discs with write-intent=
 bitmap
> if you want. (It might even be 28 discs.) And if you had an array as =
funky
> as that, you'd probably want to run LVM over the top of it, so you'd =
need an
> initrd anyway, so you'd be able to use 1.x metadata :-)
>
> Since most distros ship highly modular kernels, their installers and =
tools
> all build initrds, so for most people, needing an initrd is not an is=
sue.
>
> Anyway, a quick summary:
> * with grub 0.97 or LILO, /boot (more generally, wherever your vmlinu=
z
> lives) must be RAID-1 on 0.90 or 1.0 metadata, and the members must b=
e on
> drives the BIOS will boot from, usually sda/b/c
> * without an initrd, / must be on 0.90 metadata but any RAID level or=
 disc
> location (that the kernel doesn't need extra modules for) is fine
> * and combining these, if you're running grub 0.97 (or LILO) and don'=
t want
> a separate /boot array (or keep your vmlinuz in the root) and don't w=
ant to
> use an initrd, you're restricted to having your root filesystem on RA=
ID-1 on
> 0.90 metadata on drives the BIOS will boot from
>
> Cheers,
>
> John.
>
>
John,
   Thanks for the summary. It's succinct and covered the info I needed
this weekend.

   One question comes to mind. I'm about to build a Gentoo machine
that will run a number of copies of Windows in VirtualBox VMs. The
system will be nice, reliable RAID1 for all of Linux, and then 'fast'
RAID0 on different drives for the VM data. As there will be nothing
involved with booting Linux on this RAID - just the VM data. I assume
that there's no problem assembling RAID0 after the boot process has
essentially completed, and that this RAID could use any form of
metadata?

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
