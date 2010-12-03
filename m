From: Neil Brown <neilb@suse.de>
Subject: Re: Write cache
Date: Fri, 3 Dec 2010 12:27:39 +1100
Message-ID: <20101203122739.32af28a1@notabene.brown>
References: <AANLkTim+dHWMeZkdFuRiimmNdkZ04j9tO3DCyOPAdxJK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim+dHWMeZkdFuRiimmNdkZ04j9tO3DCyOPAdxJK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2 Dec 2010 15:58:51 +0000 mark delfman <markdelfman@googlemail.=
com>
wrote:

> Hi
>=20
> Is there any way to use an MD RAID in write through mode?  I
> appreciate that there is a performance impact but this is important
> from a security prospective....

MD RAID does work in write-through mode.  I have occasionally thought a=
bout
adding a write-back mode which would make sense now that we have a sens=
ible
flushing infrastructure in Linux.  But I haven't implemented it.

>=20
> The likelihood is that I would use RAID0 (I know this sounds like a
> contradiction to the above, but the =91drives=92 are probably hardwar=
e
> RAIDs).  But may use standard RAID6.

RAID0 doesn't do any caching at all.

>=20
> I cannot see any way to disable write cache in MD, but I am hopefully
> I am simply missing something obvious.

Why do you think these is a write-behind cache in MD ??

NeilBrown



>=20
> I appreciate any feedback....
>=20
> Thanks, Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
