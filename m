Received: from ns13.servermx.com (ns13.servermx.com [135.125.234.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00E81350FF
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.125.234.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706135188; cv=none; b=fcpjGrBx+9qZKyGBdVR1bK9Ia/cB9JqCoL2N5FXtiJz0HenNhnXtLdQjTdGLjGCG1njiSTNhpj8KDE93VBSDrdxBuhDLVk051nCYmIjcdvBblSX878ObtKIoxmMskNdCdn0GtCXeJE6lFOwuNy+Lbg6yDvF/8OUDHETGEys4alg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706135188; c=relaxed/simple;
	bh=An5KMiZvgmJX6RweLcxiHB1e+jWlfO5Sqd1F1LGahSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exZOl4+dU3tUCJjqz99NWhRtnNkso1DQMXHeZJVcXap89fRCi912neuL/JDhOe0zAnixMD2y76ZFqNQwKjrJcsFaUCzT3VyVY7ffG5lKGwOEgR+q14pudhf/JwhdlVutHakBrmlsZN7bh/XOT/576AR5GRrRrEqDIePTv/Sy264=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=robinhill.me.uk; spf=none smtp.mailfrom=robinhill.me.uk; dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b=U+VFEiin; dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b=U+VFEiin; arc=none smtp.client-ip=135.125.234.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=robinhill.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=robinhill.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b="U+VFEiin";
	dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b="U+VFEiin"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=servermx.com; s=servermx; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Bat5gveLSkbMRgrMeZfL0F1fofYGpaPQJTQue+QVQtA=; b=U+VFEiinue9eY0L4budEpdeGV5
	gixneEH3Dri3QSxBOSEaSmV1UyksAdXBnpoC0Gm9550OzDgVgPhm5q7Xy6ClAkQCh3pcqES4OR5l4
	YrR6UmZuV/uTcyKyTsS7wATrYjPg4TD5o9Vus1/9UntbWJrXiZ6vqPSKiaEev7If7A1g=;
Received: by exim4;
	Wed, 24 Jan 2024 23:22:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=servermx.com; s=servermx; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Bat5gveLSkbMRgrMeZfL0F1fofYGpaPQJTQue+QVQtA=; b=U+VFEiinue9eY0L4budEpdeGV5
	gixneEH3Dri3QSxBOSEaSmV1UyksAdXBnpoC0Gm9550OzDgVgPhm5q7Xy6ClAkQCh3pcqES4OR5l4
	YrR6UmZuV/uTcyKyTsS7wATrYjPg4TD5o9Vus1/9UntbWJrXiZ6vqPSKiaEev7If7A1g=;
Received: by exim4;
	Wed, 24 Jan 2024 23:22:06 +0100
Received: from usr01 (usr01.home.robinhill.me.uk [IPv6:2001:470:1f1d:269::50])
	by cthulhu.home.robinhill.me.uk (Postfix) with SMTP id 1A77E6A036C;
	Wed, 24 Jan 2024 22:21:54 +0000 (GMT)
Received: by usr01 (sSMTP sendmail emulation); Wed, 24 Jan 2024 22:21:54 +0000
Date: Wed, 24 Jan 2024 22:21:54 +0000
From: Robin Hill <robin@robinhill.me.uk>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: RJ Marquette <rjm1@yahoo.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Requesting help recovering my array
Message-ID: <20240124222154.GA6210@usr01.home.robinhill.me.uk>
Mail-Followup-To: Roger Heflin <rogerheflin@gmail.com>,
	RJ Marquette <rjm1@yahoo.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com>
 <20240123221935.683eb1eb@firefly>
 <1979173383.106122.1706098632056@mail.yahoo.com>
 <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
 <2058198167.201827.1706119581305@mail.yahoo.com>
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com>
 <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
Feedback-ID:outgoingmessage:robin@robinhill.me.uk:ns12.servermx.com:servermx.com

There have been reported cases of BIOSes auto-creating partitions on
disks, so this is certainly a possibility. I used to use bare disks but
have switched to partitions instead, just to prevent this sort of thing
=66rom happening.

Cheers,
    Robin

On Wed Jan 24, 2024 at 03:44:55PM -0600, Roger Heflin wrote:

> Well, if you have a /dev/sdb1 device and you think the mdadm device is
> /dev/sdb (not sdb1) then SOMEONE added a partition table at some point
> in time or you are confused what you mdadm device is.   if sdb is a
> mdadm device and it has a partition table then mdadm --examine may see
> the partition table and report that and STOP reporting anything else.
>=20
> And note that that partition table could have been added at any point
> in time since the prior reboot.  I have found (and fixed) ones that
> were added years earlier and found on the next reboot for something
> similar a year or 2 later.  On my own stuff before a hardware/mb
> upgrade i will do a reboot to make sure that it reboots cleanly as all
> sorts of stuff can happen (ie like initramfs/kernel  changes causing a
> general failure to boot).
>=20
> On Wed, Jan 24, 2024 at 3:31=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wro=
te:
> >
> > I didn't touch the drives.  I shut down the computer with everything wo=
rking fine, swapped motherboards, booted the new board, and discovered this=
 problem immediately when the computer failed to boot because the array was=
n't up and running.  I definitely haven't run fdisk or other disk partition=
ing programs on them.
> >
> > Other than the modifications to the mdadm.conf to describe the drives a=
nd partitions (none of which have made any difference), I modified my fstab=
 to comment out the raid array so the computer would boot normally.  I've b=
een trying to figure out what is going on ever since.  I've tried to avoid =
doing anything that might write to the drives.
> >
> > I thought this upgrade would take an hour or two to swap hardware, not =
days of troubleshooting.  That was the advantage of software RAID, I though=
t.
> >
> > Thanks.
> > --RJ
> >
> >
> >
> >
> > On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <rogerh=
eflin@gmail.com> wrote:
> >
> >
> >
> >
> >
> > Are you sure you did not partition devices that did not previously
> > have partition tables?
> >
> > Partition tables will typically cause the under device (sda) to be
> > ignored by all of tools since it should never having something else
> > (except the partition table) on it.
> >
> > I have had to remove incorrectly added partition tables/blocks to make
> > lvm and other tools again see the data.  Otherwise the tools ignore
> > it.
> >
> > On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> =
wrote:
> > >
> > > Other than sdc (as you noted), the other array drives come back like =
this:
> > >
> > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> > > /dev/sda:
> > >  MBR Magic : aa55
> > > Partition[0] :  4294967295 sectors at            1 (type ee)
> > >
> > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> > > mdadm: No md superblock detected on /dev/sda1.
> > >
> > >
> > > Trying your other suggestion:
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1=
 /dev/sdf1 /dev/sdg1
> > > mdadm: no recogniseable superblock on /dev/sdb1
> > > mdadm: /dev/sdb1 has no superblock - assembly aborted
> > >
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /=
dev/sdf /dev/sdg
> > > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > > mdadm: /dev/sdb has no superblock - assembly aborted
> > >
> > >
> > > Basically I've tried everything here:  https://raid.wiki.kernel.org/i=
ndex.php/Linux_Raid
> > >
> > > The impression I'm getting here is that we aren't really sure what th=
e issue is.  I think tonight I'll play with some of the BIOS settings and s=
ee if there's something in there.  If not I'll swap back to the old motherb=
oard and see what happens.
> > >
> > > Thanks.
> > > --RJ
> > >
> > >
> > >
> > >
> > >
> > > On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@peng=
uinpee.nl> wrote:
> > >
> > >
> > >
> > >
> > >
> > > On 24-01-2024 13:17, RJ Marquette wrote:
> > >
> > > > When I try the command you suggested below, I get:
> > > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g=
}1
> > > > mdadm: no recogniseable superblock on /dev/sda1
> > > > mdadm: /dev/sda1 has no superblock - assembly aborted
> > >
> > >
> > > Try `mdadm --examine` on every partition / drive that is giving you
> > > trouble. Maybe you are remembering things wrong and the raid device is
> > > /dev/sda and not /dev/sda1.
> > >
> > > You can also go through the entire list (/dev/sd*), you posted earlie=
r.
> > > There's no harm in running the command. It will look for the superblo=
ck
> > > and tell you what has been found. This could provide the information =
you
> > > need to assemble the array.
> > >
> > > Alternatively, leave sda1 out of the assembly and see if mdadm will be
> > > able to partially assemble the array.
> > >
> > > -- Sandro
> > >
> >
>=20
