From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Upgrading Raid1 array to have 2. disks.
Date: Wed, 07 May 2003 01:46:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB84948.2090401@hum.auc.dk>
References: <3EB8441F.8070606@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB8441F.8070606@fugmann.dhs.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anders Fugmann wrote:

> Sorry if this is the wrong list to post this on.

It's the right list.

> I have made an error when creating a new raid1 array as I specified t=
hat
> the raid should consist of only one disk. Now, I would like to add=20
> another disk, but mdadm insists on adding it as a spare disk, offerin=
g=20
> no data redundancy.

> I have read the manpages, and tried googling without success.
> I do not wish to destroy the data on the discs, and recreate the arra=
y=20
> but It might be a last resort. Can anyone help me convince mdadm to a=
dd=20
> the 2. partition as an active disk.

You could keep your data by doing this:

Remove the current spare:

mdadm --remove /dev/md/0 /dev/ide/host0/bus0/target0/lun0/part1[0]

Create new array with

mdadm --create /dev/md/1 --level=3D1
--raid-devices=3D/dev/ide/host0/bus0/target0/lun0/part1[0] missing

Then create fs on new array, mount & copy data to the new array. Stop t=
he old=20
array, add disk from old array to the new array.


--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
