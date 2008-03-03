From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Creating RAID5 with four devices and end up with 5 (one removed and one spare). Why?
Date: Mon, 3 Mar 2008 10:55:47 +0100
Message-ID: <fqghv3$82v$1@ger.gmane.org>
References: <47CBBD11.4020501@gmail.com> <47CBC516.5050904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tor Arne Vestb=F8 <torarnv@gmail.com> wrote:
> But does that explain why mdadm believes I have another disk, a fifth=
=20
> disk, that has been removed? The ID numbers of the real disks are=20
> 0,1,2,4 but I would expect 0,1,2,3:

Once the rebuild has finished, you will have exactly the latter.
md stores raid-disks in different slots than not-yet-raid-disks.


regards
   Mario
--=20
> As Luke Leighton said once on samba-ntdom, "now, what was that about
> rebooting?   that was so long ago, i had to look it up with man -k."

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
