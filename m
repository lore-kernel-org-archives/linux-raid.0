From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: "mdadm: Raid level 5 not permitted with --build" -- why is that?
Date: Tue, 26 Jun 2012 10:22:28 +0800
Message-ID: <CA+sTkh4yr2XV2R9bupoQjFtgS--wQVBkyrdcOJyGpAn5P861UQ@mail.gmail.com>
References: <CA+sTkh70JopNMbh0VQXDCq2MY+GHq0hQEPyKT1e9mRXxfk_2xw@mail.gmail.com>
 <20120625165242.117881e1@notabene.brown> <CA+sTkh7cYEmrujcRkvisFM1EksQBJ2kMKBfkd3RyDwr2-bvGpw@mail.gmail.com>
 <20120625175804.21b86b35@natsu> <CA+sTkh7Tv-F2fofWviF+X+Kp5-RLWmkTZveB6+jDHewLhhK50Q@mail.gmail.com>
 <4FE85C2F.5050007@hesbynett.no> <CA+sTkh53htrdUF5OUcKRa33HDmz9SHsz0=B9DvJ60uzeFST5XA@mail.gmail.com>
 <20120626111342.4a61d1e5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120626111342.4a61d1e5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 June 2012 09:13, NeilBrown <neilb@suse.de> wrote:
> On Mon, 25 Jun 2012 21:10:17 +0800 Igor M Podlesny <for.poige+lsr@gma=
il.com>
> wrote:
>
>> =C2=A0 =C2=A0It's simple matter and as to me I prefer brevity. I see=
 no purpose
>> in inflating mail body just due to it was short. It's simple matter,
>> that's why it's short, damn it.
>>
>> =C2=A0 =C2=A0And finally =E2=80=94 the fact of the reply *was* given=
 proved that the
>> question was easily understood. So what, then?
>
> This is not actually correct. =C2=A0I don't think that I did understa=
nd your
> question, as you had provided no context.
> Your question might have been:
> =C2=A01/ I was reading the man page and discovered that RAID5 is not
> =C2=A0 =C2=A0permitted with --build and wondered why.
> or
> =C2=A02/ I was reading the code and saw that RAID5 is not permitted w=
ith
> =C2=A0 =C2=A0--build and wondered why
> or
> =C2=A03/ I was trying to do XX and thought that --build might be a so=
lution
> =C2=A0 =C2=A0but I need RAID5 and --build doesn't support RAID5 - why=
 is that?
>
> Each of these could have quite different answers so I couldn't be sur=
e that
> what I would say would actually be helpful unless I answered all of t=
hem,
> which would probably be a waste of effort to some extent. =C2=A0This =
is why I felt
> that "Because!" was about all that the question really deserved.

   Look! The point is it didn't matter how and why and when I realized
it was prohibited (or not supported). That's why my question was short
=E2=80=94 just "why is that?". That's all. Don't (over) complicate it, =
it
needs not! It could possibly went further in any of the directions you
listed above (and possibly others), but it could it not as well at
all.

> I was feeling rather tired at the time which probably explains (witho=
ut
> justifying) the shortness of my answer. =C2=A0I should have realised =
that and not
> replied at all - my mistake.

   Well, as I've already noted, you at least gave an explanation
(thanks!). I still don't see much reasoning behind it, but that's
another problem (and possibly mine). It's unclear to me how one should
safely repair MD array with damaged superblocks? Should one mess with
dd-backuping of all those disks' blocks which would be overwritten by
"mdadm -C"?  "mdadm -B" would be way better, as I've already said.

> BTW I wasn't intending sarcasm at all - sorry if you thought I was.

   Neil,  this is not LSR developers' list (at least primarily) and
I'm not a kernel developer. Even though I can read code in C and come
up with patches occasionally, it would take hell a lot of time and
efforts to investigate the problem and come up with a fix, which might
be not proper finally. So, yeah, every "feel free to send a patch"
would sound sarcastic. Since it's open source software, we all
remember everyone can send a patch. So, what's the point to repeat it
over and over again, then?=E2=80=A6 (Treat it as rhetoric question).

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
