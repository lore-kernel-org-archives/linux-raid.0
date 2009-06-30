From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: What will happen with spares in this scenario?
Date: Tue, 30 Jun 2009 06:26:25 +0200
Message-ID: <87r5x2xs7i.fsf@frosties.localdomain>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com>
	<87zlbruinb.fsf@frosties.localdomain>
	<BD450977-FA0D-4F63-8ADB-1314FA43E654@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BD450977-FA0D-4F63-8ADB-1314FA43E654@googlemail.com> (John
	McNulty's message of "Mon, 29 Jun 2009 21:42:35 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John McNulty <johnmcn1@googlemail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McNulty <johnmcn1@googlemail.com> writes:

> On 29 Jun 2009, at 17:08, Goswin von Brederlow wrote:
>
>
>           So drop md1, make c0d0p1 as big as the others and then
>      partition
>      md0 eigther directly or via lvm.
>
>
>
>
> You wouldn't happen to know if it's possible to create a partitionabl=
e array
> like this in Kickstart would you? =A0 I've had a sniff around Redhat'=
s docs and
> a documented way of doing this isn't jumping out at me. =A0 =A0If I h=
ad to guess
> then it might look something like this?

Totally Debian here.

> part =A0pv.1 =A0--size 1 --ondisk cciss/c0d0 --grow --asprimary
>
> part =A0pv.2 =A0--size 1 --ondisk cciss/c1d0 --grow --asprimary
>
> raid =A0pv.3 =A0--level=3DRAID1 --device=3Dmd_d0 pv.1 pv.2
>
>
> part /boot --fstype ext3 --size 300 --ondisk md_d0
>
> part pv.4 --fstype "physical volume (LVM) --size 1 --ondisk md_d0 --g=
row
>
> volgroup system --pesize=3D32768 pv.4
> logvol / --fstype ext3 --name=3Droot --vgname=3Dsystem --size=3D51200
> logvol swap --fstype swap --name=3Dswap --vgname=3Dsystem --size=3D81=
92

Hmm, do I understand this right that you want 2 partitions. One for
/boot and one for everything else on lvm?

Just a crazy idea. But why not put /boot on lvm too and use grub2 or
lilo as bootloader? Or does Kickstart not allow that?

> This might be a bit ambitious, and I can't see an option to "raid" th=
at would
> tell it to create a partitionable raid device, i.e. run --auto=3Dmdp =
behind the
> scenes. =A0 Unless it takes a hint from the device name and does that=
 without
> asking?
>
>
>
> The systems I'm working on are to be kickstarted from a Spacewalk ser=
ver.
>
>
>
> Rgds,
>
>
>
> John

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
