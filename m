From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: raid0 + raid1 question
Date: Thu, 9 Oct 2003 11:55:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031009095500.GA20643@marowsky-bree.de>
References: <3F84793F.6060400@siue.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F84793F.6060400@siue.edu>
To: anthony mayes <anmayes@siue.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-08T15:53:19,
   anthony mayes <anmayes@siue.edu> said:

> I have 7 disks in an x86 box.  I want to have 2 raid0's (concatenatio=
ns)=20
> of 3 disks each.  Then I want to raid1 (mirror) the raid0's.   This=20
> leaves 1 disk for the OS.

That is a suboptimal allocation and will actually increase the
likelihood of failure. What you want to do is to have 3 raid1's of 2
disks each and to concatenate these 3 via raid0 or LVM.

And why are you not placing the OS itself on a RAID too? If the system
goes down, so will your application.

> with the afore mentioned configuration. First the mirror is broken an=
d=20
> half of the mirror is mounted as another filesystem while the=20
> application continues to run on the other half of the mirror.  The=20
> backup is performed and then the mirror is resync'ed.  However, I wan=
t=20
> to move to x86 and linux and need to know if the same is possible and=
=20
> how to do it.  Does anyone have any experience / advise?

You should concat the 3 raid1's via LVM and use LVMs snapshot facility.
(Google for the howto)


Mit freundlichen Gr=FC=DFen,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
