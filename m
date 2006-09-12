From: dean gaudet <dean@arctic.org>
Subject: Re: access *existing* array from knoppix
Date: Tue, 12 Sep 2006 11:17:12 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609121113030.18380@twinlark.arctic.org>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
 <200609121607.22031.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609121008050.19418@p34.internal.lan>
 <200609121637.53998.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121637.53998.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Sep 2006, Dexter Filmore wrote:

> Am Dienstag, 12. September 2006 16:08 schrieb Justin Piszcz:
> > /dev/MAKEDEV /dev/md0
> >
> > also make sure the SW raid modules etc are loaded if necessary.
> 
> Won't work, MAKEDEV doesn't know how to create [/dev/]md0.

echo 'DEVICE partitions' >/tmp/mdadm.conf
mdadm --detail --scan --config=/tmp/mdadm.conf >>/tmp/mdadm.conf

take a look in /tmp/mdadm.conf ... your root array should be listed.

mdadm --assemble --config=/tmp/mdadm.conf --auto=yes /dev/md0

-dean
