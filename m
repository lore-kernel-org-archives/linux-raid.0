From: David Greaves <david@dgreaves.com>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 16:27:14 +0100
Message-ID: <42652352.3050706@dgreaves.com>
References: <200504191100.NAA01462@node130.rhm.de> <20050419144011.GI3103@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050419144011.GI3103@eychenne.org>
Sender: linux-raid-owner@vger.kernel.org
To: rv@eychenne.org
Cc: bernd@rhm.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herv=E9 Eychenne wrote:
> On Tue, Apr 19, 2005 at 01:00:11PM +0200, bernd@rhm.de wrote:
>>First you have to look if there are partitions on that disk to which =
no
>>data was written since the disk failed (this typically concerns the s=
wap
>>partition). These partitions have to be marked faulty by hand using m=
dadm -f
>>before you can remove them with mdadm -r.
>=20
>=20
> Ok, but how do you automate/simplify that?

EVMS?
Or some other enterprise volume manager


>=20
> A script with a while loop and some grep,sed commands? A grep on what
> exactly? (this kind of precise information seems to be written nowher=
e in
> the manpage of the HOWTOs)
You're talking about specific configs - not all sysadmins will want to=20
do this.
And those who do can type:
   fdisk -l /dev/sda | grep -i fd | cut -f1 -d' ' | xargs -n1 mdadm -r

> Wouldn't it be much simpler if it could be possible to do something
> like the following?
> # mdadm --remove-disk /dev/sda
> So this command could mark as faulty and remove of the array any
> implied partition(s) of the disk to be removed.

see above 1 liner...

David

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
