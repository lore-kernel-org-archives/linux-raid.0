From: Jens Benecke <jens@spamfreemail.de>
Subject: RE: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 05 Aug 2004 14:08:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cet7vc$mt7$1@sea.gmane.org>
References: <cesjcm$9da$1@sea.gmane.org> <S267610AbUHEJ5F/20040805095705Z+97@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

robin-lists@robinbowes.com wrote:

>> >> How about RAIDing the root partition? If one drive fails will the
>> >> other be able to boot via LILO? How about GRUB? Which do
>> >=20
>> > I have my root partition on a RAID1 mirror. I use grub and have
>> > "installed" grub to both mirrored drives so I can boot off either,
>> > e.g. if one fails. That reminds me, I must test this.
>>=20
>> That's exactly what I want.
>=20
> I've got some rough notes I made. I may tidy them up and publish them=
 on
> my web site.

Hi Robin,

I'm still a bit torn between buying a 3ware hardware RAID for =A4140.- =
and
just using 'md'. The box is an Athlon64 3GHz, so it'll have enough CPU
power to do the RAID in software, but with partitioning etc, I think th=
e
hardware raid will be easier to handle because you can just ignore it. =
As
long as the 3ware BIOS will handle failing drives, read/write errors, e=
tc
etc. properly.

Right?
   =20
>> > keep /var/tmp and /tmp on the root partition.
>>=20
>> No. I don't want a rogue script to fill up my root partition.
>=20
> That, of course, is the reason you would want to keep /var/tmp and/or=
 /tmp
> on separate partitions (or on the same partition - just symlink so
> /var/tmp and /tmp are the same.)

I would probably not symlink but I'd put them both on the same partitio=
n.=20
 =20
>> What I mean is, will md resync automatically or would I have
>> to initiate this manually?
>=20
> Md should re-sync automatically.

=2E.. even onto a new blank disk? Or would you have to tell md manually=
 "this
is the new spare, please sync"? Is this easy to do? Something like

        - copy partition table
        - for FOO in 1 2 3 4 5 ; do tell md "sync hda$FOO to hdc$FOO"

or is it more complicated?
=20
>> This setup seems quite complicated. Did you test the setup,
>> ie. removed one of the MD disks and looked what happened?
> I deliberated long and hard about how to implement my new system and =
this
> was about the least complicated route!

Oh. ;)
=20

>> >> The goal is to have as "stress free" a system as possible
>> >> as little manual configuration, and in event of emergencies, as
>> >> little work to do, as possible.
>> > If you want stress free, buy a Netapps storage appliance ;o)
>> If they do all the rest that I need (smtp, web, file server,
> I was being slightly slippant - Netapps just do big storage arrays wi=
th
> very high availability. For example, if they detect that a drive is
> failing they send an email to Netapps and an engineer comes round wit=
h a
> replacement disk all without any user intervention! I guess they're t=
he
> Rolls Royce of storage solutions. Expensive though.

Ah. Well I don't think this'll fit in our budget. :)


--=20
Jens Benecke
http://www.hitchhikers.de - Europas kostenlose Mitfahrzentrale seit 199=
8
http://www.rb-hosting.de - Webhosting mit Extras - PHP ab =A49 - SSH ab=
 =A419
http://www.spamfreemail.de - 100% saubere Postf=E4cher, garantiert!

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
