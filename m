From: Maarten v d Berg <maarten@vbvb.nl>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 13:10:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401201310.48900.maarten@vbvb.nl>
References: <400CD0BF.2010808@upfrontsystems.co.za> <16396.64514.820157.677722@notabene.cse.unsw.edu.au> <400D05AC.4030409@upfrontsystems.co.za>
Reply-To: maarten@nebula.vbvb.nl
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400D05AC.4030409@upfrontsystems.co.za>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 20 January 2004 11:40, Jean Jordaan wrote:
> Neil,
>
> thank you very much for your help ..
>
> >  mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3
>
> Did that, once with 'missing' in each place. All I get:
>
> cdimage root # mdadm --create /dev/md0 --raid-devices=3 --level=5
> --spare-devices=0 --chunk=64 missing /dev/hdb3 /dev/hdc3
> mdadm: /dev/hdb3 appears to be part of a raid array:
>      level=5 devices=3 ctime=Tue Jan 20 10:35:45 2004
> mdadm: /dev/hdc3 appears to be part of a raid array:
>      level=5 devices=3 ctime=Tue Jan 20 10:09:43 2004
> Continue creating array? y
> mdadm: array /dev/md0 started.
> cdimage root # mount -r -t reiserfs /dev/md0 /mnt/gentoo/raid/
> mount: Not a directory

Note that it says "Not a directory".  Not something like "can't read 
superblock" or "is not a valid block device" or similar errors which would 
indicate an error with the md array. 
So, maybe mount is right and /mnt/gentoo/raid/ IS actually wrong...?

Furthermore, you're not realizing that reiserfs will try to replay its 
transactions when you attempt a mount, even if mounting RO afaik.
So maybe more prudent would be a reiserfsck --check...

Maarten

