From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Moved drives between machines... now, MIA.
Date: Fri, 29 Jan 2010 23:23:59 -0500
Message-ID: <7d86ddb91001292023x5986f9e6j5d9c2e4e62d5be06@mail.gmail.com>
References: <b54b3e55942c56b2ec1f69d80f54eaea.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b54b3e55942c56b2ec1f69d80f54eaea.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 1:52 PM, Ken D'Ambrosio <ken@jots.org> wrote:
> Okay, so I swapped six drives from one machine to another. =A0I was v=
ery,
> very careful to ensure that the drives were plugged in in the
> corresponding order that they'd been plugged in in the first machine.
> Now, fdisk shows no partitions in two of my three mirrors. =A0This fi=
lls me
> with a distinct lack of warmth and fuzziness. =A0/etc/mdadm/mdadm.con=
f
> addresses the two (MIA) mirrors with /dev/sd[abef]1 designators, whic=
h
> can, of course, get jumbled in a transition. =A0Any tips on how to go
> forward would be gratefully appreciated -- I *really* don't want to h=
ave
> to go to backups.
>
> Thanks!
>
> -Ken
>
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You did make a new mdadm.conf with the correct devices for each array
right? If not try running and seeing if your arrays come up. If they
do then copy /tmp/mdadm.conf to /etc/mdadm/mdadm.conf

mdadm --examine --scan --config=3Dpartitions > /tmp/mdadm.conf
mdadm --assemble --scan --config=3D/tmp/mdadm.conf

Ryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
