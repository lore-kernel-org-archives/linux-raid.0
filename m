From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 16:40:11 +0200
Message-ID: <20050419144011.GI3103@eychenne.org>
References: <200504191100.NAA01462@node130.rhm.de>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200504191100.NAA01462@node130.rhm.de>
Sender: linux-raid-owner@vger.kernel.org
To: bernd@rhm.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 19, 2005 at 01:00:11PM +0200, bernd@rhm.de wrote:

> >You have to mdadm -r remove it and re-add it once you restore the di=
sk.

> First you have to look if there are partitions on that disk to which =
no
> data was written since the disk failed (this typically concerns the s=
wap
> partition). These partitions have to be marked faulty by hand using m=
dadm -f
> before you can remove them with mdadm -r.

Ok, but how do you automate/simplify that?

A script with a while loop and some grep,sed commands? A grep on what
exactly? (this kind of precise information seems to be written nowhere =
in
the manpage of the HOWTOs)

Wouldn't it be much simpler if it could be possible to do something
like the following?
# mdadm --remove-disk /dev/sda
So this command could mark as faulty and remove of the array any
implied partition(s) of the disk to be removed.
Does this currently exist?  If not, would you be willing to integrate a=
 patch
in that sense? It would be much simpler, don't you think?

Same thing for addition...
# mdadm --add-disk /dev/sda
would do the job quite automatically...

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
