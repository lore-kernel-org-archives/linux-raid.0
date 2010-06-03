From: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Subject: Re: Question about preferred minor.
Date: Thu, 3 Jun 2010 07:15:29 -0400
Message-ID: <AANLkTiml0UzRAPB2lHNDxe_6k_G17eAq8P_TtxqLYHmg@mail.gmail.com>
References: <AANLkTimbMat99Su8F4FauQIa8mpeZJk6syJ0oXjHyygG@mail.gmail.com>
	<loom.20100603T104147-488@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100603T104147-488@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the past without knowing exactly why I have experienced failed
assemblies upon a reboot. I have seen correction in this behavior by
properly populating my /etc/mdadm/mdadm.conf file.

I typically log in as root and do this:

mdadm --examine --scan --config=3Dmdadm.conf >> /etc/mdadm/mdadm.conf

Clean up is typically needed.

So could this be an indication that my super-blocks on this particular
array have some discrepancies? Notably the hostname?

I tend to worry about my daters incessantly...

On Thu, Jun 3, 2010 at 4:42 AM, Christian Gatzemeier
<c.gatzemeier@tu-bs.de> wrote:
> Andrew Dunn <andrew.g.dunn.dod <at> gmail.com> writes:
>
>> What is the meaning of Preferred Minor : 2 ?
>
> Most of the time that array will get assembled as md2, but conflicts,
> other numbers and errors stemming from differently assembled arrays c=
an
> occur.
>
> From https://wiki.ubuntu.com/ReliableRaid:
> "Mdadm is setting up arrays according to unreliable superblock
> information. (Device "minor" numbers, labels and hostnames in
> superblocks are not sure to be unique and can be outdated.) This is
> combined with the idea of fixing the unreliability by limiting array
> assembly with information from mdadm.conf. (Defining PARTITIONS, ARRA=
Y,
> HOMEHOST lines.) Consequently this forces setup tools, admins and
> installers to create mdadm.conf files and subjects them to the exact
> same reliability problems."
>
> I guess this conflict prone behavior is mostly legacy behavior from t=
he
> past, or is there still an apparent reason to expose dynamic kernel
> internals like the minor to userspace instead of basing device node n=
ame on
> "md-UUID"?
>
> Regards,
> Christian
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
