From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 07:50:51 -0700
Message-ID: <AANLkTinmatSeQLUi23R4l7icicHYqdE8Ae6M4zSHjf7H@mail.gmail.com>
References: <AANLkTil0Y-mXuoibzPUWtxKML8K0iRaz9mCxL3_40XSB@mail.gmail.com>
	<3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jun 5, 2010 at 10:19 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> >> problem. This method does require that I update the two backups b=
y
>> >> hand once in awhile. That's OK by me.
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Define, "once in awhile [sic]".
>>
>> Every 2-3 months I make sure each drive is up to date.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I was having to update one server or the o=
ther every week or so,
> sometimes more than once a week. =C2=A0I could have written scripts t=
o do it, or
> used rsync, I suppose, but I opted for RAID1.
>

I can see that. My point of view was (I think) more in line with the
OP's title of this thread, being a home server. I have only 1 home
server. I suspect he does also as it's his first time doing RAID, as
it was for me.

<SNIP>
>>
>> As I said I don't using an initrd. I've never learned how to build o=
ne
>> and didn't need it if I didn't use RAID on /boot.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Most distros these days employ an initrd. =
=C2=A0One re-builds it by
> running whatever application is included with the distro for that pur=
pose.
> In the case of Debian and Debian derivatives, it is currently
> `update-initramfs`. =C2=A0It's built the first time by installing a L=
inux distro.
> It's not that difficult to do by hand, however. =C2=A0Most are built =
using cpio
> and gzip. =C2=A0Once one has the directory structure one wishes, one =
simply
> creates a compressed tarball (cpioball?) from the structure. =C2=A0It=
 includes a
> copy of /etc, with some special scripts to allow the system to work p=
rior to
> the existence of the "real" /.
>
>> I don't understand your comments about /etc as it's not kept in /boo=
t.
>> /etc, /, /home, and all other directories are on RAID. Only /boot
>> isn't, so it needs only a kernel and grub.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0The initrd has a copy of /etc - especially=
 the boot configuration
> files such as mdadm.conf, fstab, etc.

Ah, OK. Well again, as I don't use an initrd or even know what it is I
have a lot of learning to do in that area. I've just never bothered.
I've run Linux as a desktop system for about 13 or 14 years now. Maybe
some other distros used initrd by default but Gentoo, which I've run
since about 2000 or so, doesn't require it. For desktop systems based
on lowest common denominator PC hardware it's never seemed to provide
any real advantage. Certainly it does for bigger servers where you
guys buy fancy hard drive controllers and the like.

But again, I'm talking about something I don't use and don't know much
about so I have a pretty limited perspective. Getting started with
RAID is the first time I've seen the value for my machines, and then
only for the boot partition.

Thanks!

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
