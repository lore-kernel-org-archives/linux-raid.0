From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 17:54:47 +0200
Message-ID: <20050419155447.GJ3103@eychenne.org>
References: <200504191100.NAA01462@node130.rhm.de> <20050419144011.GI3103@eychenne.org> <42652352.3050706@dgreaves.com>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42652352.3050706@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: bernd@rhm.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 19, 2005 at 04:27:14PM +0100, David Greaves wrote:

> Herv=E9 Eychenne wrote:
> >On Tue, Apr 19, 2005 at 01:00:11PM +0200, bernd@rhm.de wrote:
> >>First you have to look if there are partitions on that disk to whic=
h no
> >>data was written since the disk failed (this typically concerns the=
 swap
> >>partition). These partitions have to be marked faulty by hand using=
 mdadm=20
> >>-f
> >>before you can remove them with mdadm -r.
> >
> >
> >Ok, but how do you automate/simplify that?

> EVMS?

I didn't experience this yet.  By I currently have RAID1 setup with
mdadm at hand, and I must deal with it...

> Or some other enterprise volume manager

No, thanks. ;-)
I prefer taking time to improve free (as a speech) tools than turning
to other solutions.

> >A script with a while loop and some grep,sed commands? A grep on wha=
t
> >exactly? (this kind of precise information seems to be written nowhe=
re in
> >the manpage of the HOWTOs)

> You're talking about specific configs - not all sysadmins will want t=
o=20
> do this.

Of course not all sysadmins will want to do this, but that's not
really the question... The question is "why not provide something simpl=
e
to those who want?"

> And those who do can type:
>   fdisk -l /dev/sda | grep -i fd | cut -f1 -d' ' | xargs -n1 mdadm -r

I really don't like kludgy things like that...
What if the string fd is present in another line? No, that's really
ugly, sorry. Ok, maybe you'll come one day with a better command
line. But then it will be too complex to remember. So you'll tell me to
save it in a script. But that script will stay a bit kludgy anyway
and it will not be present on any Linux box.
Isn't the insertion/removal of a disk common enough to justify the
addition of a simple and clean mdadm option?

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
