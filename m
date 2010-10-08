From: CoolCold <coolthecold@gmail.com>
Subject: Re: Ok, dumb question time ...
Date: Fri, 8 Oct 2010 22:01:41 +0400
Message-ID: <AANLkTinw+4N63KqLGadYeHiiCg_LjYWSHKBfdsMRPBGJ@mail.gmail.com>
References: <4CAE9C13.3060002@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CAE9C13.3060002@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 8, 2010 at 8:20 AM, Joe Landman
<landman@scalableinformatics.com> wrote:
> Not having much luck with this. =A0Let me explain ...
>
> Imagine we have a RAID1 with 3 elements. =A0It was originally a RAID1=
 with 2
> elements, and we added a 3rd using
>
> =A0 =A0 =A0 =A0mdadm /dev/md0 --add /dev/loop1
>
> What I want to do is conceptually very simple. =A0I want to permanent=
ly remove
> loop1, without having the array become dirty, or degraded. =A0That is=
, I would
> like
>
> =A0 =A0 =A0 =A0mdadm /dev/md0 --fail /dev/loop1 --remove /dev/loop1
>
> to result in a clean array with two members.
>
> It doesn't. =A0The array is marked as being in the "clean, degraded" =
state.
> =A0Which, as it is the root file system array, has the unfortunate si=
de effect
> of not allowing the RAID1 to properly assemble at boot (that degraded
> state).
Am I understanding right, you can't boot because that md array isn't
assembled at all or just assembled but degraded?
If first, are you happy Ubuntu user?
>
> So ... can I force the array to either remove the extra unneeded loop=
1
> device, and update its metadata properly ... or force it into a clean=
,
> active state without the loop1 device, or force the assembly on boot =
to
> occur regardless of what it thinks it should have?
>
> This is quite disconcerting ... I thought it would be simple.
> --
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics, Inc.
> email: landman@scalableinformatics.com
> web =A0: http://scalableinformatics.com
> =A0 =A0 =A0 http://scalableinformatics.com/jackrabbit
> phone: +1 734 786 8423 x121
> fax =A0: +1 866 888 3112
> cell : +1 734 612 4615
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
