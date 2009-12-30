From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Wed, 30 Dec 2009 16:37:59 +1100
Message-ID: <20091230163759.44ca1c0d@notabene.brown>
References: <0B.0F.01470.82CA23B4@cdptpa-omtalb.mail.rr.com>
	<04.ED.07778.434EA3B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <04.ED.07778.434EA3B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 29 Dec 2009 23:25:02 -0600
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 
> 	I never received a response on this one either.  Can anyone guess
> why one of my systems would suddenly start claiming it doesn't recognize the
> superblock versions?  The two systems are highly similar.
> 
...
> > RAID-Server:/etc/rcS.d# mdadm -V
> > mdadm - v2.6.7.2 - 14th November 2008
> > RAID-Server:/etc/rcS.d# mdadm --detail --scan
> > ARRAY /dev/md0 level=raid6 num-devices=10 metadata=01.02 spares=1
> > name=RAID-Server:0 UUID=5ff10d73:a096195f:7a646bba:a68986ca
> > 
> > Backup:/etc/initramfs-tools# mdadm -V
> > mdadm - v2.6.7.2 - 14th November 2008
> > Backup:/etc/initramfs-tools# mdadm --detail --scan
> > mdadm: metadata format 01.02 unknown, ignored.
>
Fixed in 2.6.8

NeilBrown

