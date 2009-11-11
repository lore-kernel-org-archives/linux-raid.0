From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: need help: corrupt files on one of my raids
Date: Wed, 11 Nov 2009 02:25:28 -0600
Message-ID: <20091111082537988.QJQY3390@cdptpa-omta03.mail.rr.com>
References: <4AFA72B8.8010802@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFA72B8.8010802@langseid.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> creator:~# mdadm  -D /dev/md1
> /dev/md1:
>          Version : 00.90
> 
> Is it a big problem running version 0.9? I use the version of the tools
> that comes with Debian - and as they are "some" conservative their
> versions lags some behind.

	Debian is very conservative, but that's not the issue, here.

> I have now upgraded my Debian Etch to Debian Lenny and have this mdadm:
> creator:~# mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
> 
> When I fix the firmware issues on my motherboard or buys a sepparate
> sata controller.... will the superblock be one of the version you
> suggests when I create the raid again?

	It will, but not only with Debian.  All current releases of mdadm
still default to a 0.9 superblock.  Neil has been talking about changing
that, but as of now it is still true for all versions of mdadm.  I think it
was even true for mdadm 3.1, which was withdrawn.

> If not is it that large problem
> and I should upgrade my tools beyond what Debian provides?

	There's nothing truly horrible about a 0.9 superblock, unless your
RAID array is going to grow to be quite large.  The existing tools allow a
version 1.x superblock, but you must select the version yourself when you
create the array.  If you don't, it will default to 0.9.

