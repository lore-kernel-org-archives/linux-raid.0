From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Removing a RAID 1 setting without loosing data
Date: Sat, 13 May 2006 15:50:51 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0605131548450.19433@lion.drogon.net>
References: <1147531525.6198.8.camel@nachus.raulgomez.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1147531525.6198.8.camel@nachus.raulgomez.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ra=FAl_G=F3mez?= Cabrera <raulgomezc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 May 2006, Ra=FAl G=F3mez Cabrera wrote:

> Hi everyone,
>
> I have a installed a system (mail server) wich had a RAID 1 (software=
)
> with two SCSI Disk running on Linux. The sdb disk has failed a few mo=
nth
> ago and the system is still working as expected.
>
> Since the failure of the disk I've looking for a replacement, but so =
far
> I cannot find a new one to replace it.
>
> My client (who owns the system) ask me to simply remove the failed di=
sk
> and the RAID settings, but I'm not sure if I just simply remove
> the /dev/md0 from the fstab and from the bootloader and point the / t=
o
> the sda1 (a Linux RAID partition).
>
> Anyone can help me with this situation???

I'd just halt the server and remove the failed disk and would leave all
the RAID stuff in-place as theres no need to remove it, really. It soun=
ds
like your client thinks there might be issues, but there really shouldn=
't
be any. (nor performance issues either)

Why can't you find a replacement disk? You can always put in a bigger o=
ne
if neccessary...

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
