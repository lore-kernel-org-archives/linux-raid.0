From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 14:49:48 -0500
Message-ID: <20090420194956144.ESZJ23317@cdptpa-omta01.mail.rr.com>
References: <20090420181736.GB4236@lazy.lzy>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090420181736.GB4236@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >  mdadm --create /dev/md/foo --metadata 1.0 --level .....
> >
> > This will store the name 'foo' in the metadata and when you assemble
> > the array, it will be called /dev/md/foo.
> > This will be a symlink to /dev/md125 or something like that, but you
> > don't need to care.
> 
> Does this really work with mdadm 2.6.7.1?
> 
> Because I have this from "--examine --scan"
> 
> ARRAY /dev/md/boot level=raid1 metadata=1.0 num-devices=2
> UUID=edb4254d:4274fac1:dd6cad61:a8e3c347 name=boot

Um, this is slightly odd, but when I use --examine --scan on my array, it
returns nothing.  If I run it on an element of the array I get:

ARRAY /dev/md0 level=raid6 num-devices=10
UUID=5a53eeb8:4d87963b:4cb502e9:37bde716

'Nothing about the metadata or the array name.

> Of course, /dev/mdadm.conf has the same entry.

Um, did you mean /etc/mdadm/mdadm.conf?  I don't have a /dev/mdadm.conf on
my system.

