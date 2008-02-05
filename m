From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Auto generation of mdadm.conf  (was: Deleting mdadm RAID
 arrays)
Date: Tue, 5 Feb 2008 15:47:13 +0100
Message-ID: <20080205154713.0ccae001@szpak>
References: <200802051142.19625.admin@domeny.pl>
	<20080205132717.238c4312@szpak>
	<47A86A12.2090405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A86A12.2090405@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev said:     (by the date of Tue, 05 Feb 2008 16:52:18 +0300)

> Janek Kozicki wrote:
> > I'm not using mdadm.conf at all. 
> 
> That's wrong, as you need at least something to identify the array
> components. 

I was afraid of that ;-) So, is that a correct way to automatically
generate a correct mdadm.conf ? I did it after some digging in man pages:

  echo 'DEVICE partitions' > mdadm.conf
  mdadm  --examine  --scan --config=mdadm.conf >> ./mdadm.conf 

Now, when I do 'cat mdadm.conf' i get:

 DEVICE partitions
 ARRAY /dev/md/0 level=raid1 metadata=1 num-devices=3 UUID=75b0f87879:539d6cee:f22092f4:7a6e6f name='backup':0
 ARRAY /dev/md/2 level=raid1 metadata=1 num-devices=3 UUID=4fd340a6c4:db01d6f7:1e03da2d:bdd574 name=backup:2
 ARRAY /dev/md/1 level=raid5 metadata=1 num-devices=3 UUID=22f22c3599:613d5231:d407a655:bdeb84 name=backup:1

Looks quite reasonable. Should I append it to /etc/mdadm/mdadm.conf ?
This file currently contains: (commented lines are left out)

  DEVICE partitions
  CREATE owner=root group=disk mode=0660 auto=yes
  HOMEHOST <system>
  MAILADDR root

This is the default content of /etc/mdadm/mdadm.conf on fresh debian
etch install.

best regards
-- 
Janek Kozicki
