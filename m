From: Hannes Reinecke <hare@suse.de>
Subject: Re: URE, link resets, user hostile defaults
Date: Mon, 4 Jul 2016 08:00:43 +0200
Message-ID: <5779FB8B.70708@suse.de>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <20160629121751.GT15597@hungrycats.org>
 <CACsGCyRd388u4XXCSnoK4TpNoPibjhdgEJsHS=vR6aztDc=+2A@mail.gmail.com>
 <CAJCQCtT2Sxi1GgmNaO8i46LuELpA_nrWLnVzAQMz7Qx_mdwXvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtT2Sxi1GgmNaO8i46LuELpA_nrWLnVzAQMz7Qx_mdwXvw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Edward Kuns <eddie.kuns@gmail.com>
Cc: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/01/2016 10:43 PM, Chris Murphy wrote:
> Here's a fun one of these I just got off the Fedora users mailing lis=
t
> with a laptop drive that's apparently hanging on *write*. This I woul=
d
> not expect to take a long time for a drive to figure out, but... ther=
e
> are more resets than there are write errors, and in fact there's no
> discrete write error from the drive, all we know is the failed comman=
d
> is a WRITE command.
>=20
> What seems to happen is, everything in the queue gets obliterated in
> the reset, and when ext4 finds out everything failed, not just one
> write, it barfs and goes read only.
>=20
> http://pastebin.com/3JAL297z
>=20
> How might this turn out differently if the drive reported a single
> discrete write error? I don't know how any file system tolerates this
> because it's so rare. Would ext4 just try to write again? Would it tr=
y
> to write to the same sector or another one? Or maybe the write finall=
y
> succeeds by resulting in a remap (?) But this sure is dang slow to
> recover from a bad write. I don't understand the engineering rational
> for this. Maybe it's a firmware bug?
>=20
>=20
Could be. At the very least it's an issue with EH interaction.
ATA COMRESET fails, ie libata EH fails to reset the SATA link.
Which is pretty terminal, so the device is set to offline afterwards.

This is most definitely an ATA issue, and doesn't really belong in this
context.
(Have you reported it on linux-ide?)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
