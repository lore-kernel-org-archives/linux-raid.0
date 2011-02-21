From: Mark Knecht <markknecht@gmail.com>
Subject: Re: New machine, new RAID, wrong device name...
Date: Mon, 21 Feb 2011 14:14:45 -0800
Message-ID: <AANLkTi=XWrS4i_Ytd7vecaQ2UCxFzQOQ5MDiG6=2Tdh+@mail.gmail.com>
References: <AANLkTin=E7m==Q0NASXv72jiB0h3XJhZ4-vsxCS6CvJU@mail.gmail.com>
	<20110222082312.75a72657@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222082312.75a72657@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 21, 2011 at 1:23 PM, NeilBrown <neilb@suse.de> wrote:
<SNIP>
>>
>> However once I've rebooted using the CD, and even though the machine
>> is once again called livecd the RAID is now called /dev/md127. I
>> assume, but don't know for sure, that something similar is happening
>> when I boot the actual installation, mdadm gives the RAID a differen=
t
>> name and it's likely not found by my new environment.
>
> If it is being assembled as md127 even though the host name is livecd=
, the
> implication is that the hostname is not set un after the array is ass=
embled.
> Maybe they are done in the initrd in the wrong order?
> If you
> =C2=A0 mdadm -S /dev/md127
> =C2=A0 mdadm -As
> from the livecd, does it then assemble as /dev/md3?
>

It does.

>>
>> What's the right solution to changing the RAID naming in the
>> superblock so that the laptop finds it as local to 'laptop1' and
>> mounts it according the fstab?
>
> I think you are asking how to change the name recorded in the metadat=
a.
> When booted into the livecd:
> =C2=A0 mdadm -S /dev/md127
> =C2=A0 mdadm -A /dev/md3 --update=3Dhomehost --homehost=3Dlaptop1 /de=
v/sd[ab]3
>
> should do it.
>
> NeilBrown

Thanks Neil. That looks good.

I'll now work on making sure I can actually boot the machine and sync
into Linux correctly.

I appreciate the help.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
