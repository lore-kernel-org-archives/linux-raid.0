From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm 3.1.1: level change won't start
Date: Tue, 29 Dec 2009 23:43:14 -0600
Message-ID: <13.58.08392.978EA3B4@cdptpa-omtalb.mail.rr.com>
References: <20091230163759.44ca1c0d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230163759.44ca1c0d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > 	I never received a response on this one either.  Can anyone guess
> > why one of my systems would suddenly start claiming it doesn't recognize
> the
> > superblock versions?  The two systems are highly similar.
> >
> ...
> > > RAID-Server:/etc/rcS.d# mdadm -V
> > > mdadm - v2.6.7.2 - 14th November 2008
> > > RAID-Server:/etc/rcS.d# mdadm --detail --scan
> > > ARRAY /dev/md0 level=raid6 num-devices=10 metadata=01.02 spares=1
> > > name=RAID-Server:0 UUID=5ff10d73:a096195f:7a646bba:a68986ca
> > >
> > > Backup:/etc/initramfs-tools# mdadm -V
> > > mdadm - v2.6.7.2 - 14th November 2008
> > > Backup:/etc/initramfs-tools# mdadm --detail --scan
> > > mdadm: metadata format 01.02 unknown, ignored.
> >
> Fixed in 2.6.8
> 
> NeilBrown

	Oh, OK.  Thanks Neil.  When 2.6.8 is moved into a stable version of
Debian, it will get picked up automatically.  Since it doesn't seem to
impact reliability, I can wait.

