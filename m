From: Tobias McNulty <tobias@caktusgroup.com>
Subject: Re: permanently removing a spare
Date: Tue, 17 May 2011 15:09:18 -0400
Message-ID: <BANLkTim+8mu9xuUsQvCXPXUSVLfpveGofg@mail.gmail.com>
References: <BANLkTinbk9VMuiLNUA8VW-gE1Znbf9caWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinbk9VMuiLNUA8VW-gE1Znbf9caWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 11, 2011 at 9:49 PM, Tobias McNulty <tobias@caktusgroup.com=
> wrote:
>
> Hi all,
>
> After successfully converting my raid6 array to raid5, I of course
> neglected to update mdadm.conf, so the array was absent on reboot. =A0=
A
> quick mdadm --assemble brought the array back online.
>
> However, now I am trying to update mdadm.conf, and I hit what I think
> is this bug:
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D610184
>
> So I thought I'd try to remove the spare from my raid5 array. =A0I
> marked it as failed and then removed it, and the spare no longer show=
s
> in /proc/mdstat:
>
> md0 : active raid5 sda[0] sdd[3] sdc[2] sdb[1]
> =A0 =A0 =A05860543488 blocks level 5, 64k chunk, algorithm 2 [4/4] [U=
UUU]
>
> However, when I do mdadm -Es, I still see it:
>
> ARRAY /dev/md0 UUID=3D25a818ff:68f07e28:0d7656f3:2f233380
> =A0 spares=3D1
>
> And I still see the "error: superfluous RAID member (4 found)." error
> when running update-grub (even if I leave out the spares=3D1 part).
>
> Is there a way to "permanently" remove the spare "slot" from the
> array? =A0I tried mdadm --grow --spare-devices=3D0, since the man pag=
e
> arguably suggests that --spare-devices should work in grow mode, but
> running the command reports that it's not actually supported. =A0To t=
he
> credit of the man page, the description of --spare-devices *does* say
> it is used in the *initial* array creation.
>
> Does what I'm trying to do make sense? =A0Is there a way to make the
> array forget that it ever had a spare in the first place?
>
> I'm a little afraid to reboot until I get this figured out.

Hey all - I think I am missing something obvious but I am not sure
what it is, and I still haven't turned up anything in my own
searching.

Do you have any advice for what I need to do so that the array is
mounted automatically on boot again?

Thank you!
Tobias
--
Tobias McNulty, Managing Member
Caktus Consulting Group, LLC
http://www.caktusgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
