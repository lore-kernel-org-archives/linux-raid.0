From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: mounting /dev/hdax and xfs problems
Date: Tue, 7 Oct 2003 13:26:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031007112622.GI28158@marowsky-bree.de>
References: <S262703AbTJDX0w/20031004232652Z+8001@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <S262703AbTJDX0w/20031004232652Z+8001@vger.kernel.org>
To: Nerijus Baliunas <nerijus@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-05T02:26:02,
   Nerijus Baliunas <nerijus@users.sourceforge.net> said:

> When mounting /dev/hda2 it succeeds. The question is -
> does mounting part of raid1 mirror when raid is still running
> do anything bad for a raid? How raid works in this situation -
> is it still mirroring info from /dev/hda2 to /dev/hdb2?
> If I raidstop and raidstart, can it damage filesystem?

Yes. Your data is toast.

You need to trigger a full resync from hda2 to hdb2 manually.

I think
	mdadm /dev/md0 -f /dev/hdb2 -r /dev/hdb2 -a /dev/hdb2

should do it.

You must NEVER modify an underlaying device of a raid set. This will
cause problems.


Sincerely,
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
