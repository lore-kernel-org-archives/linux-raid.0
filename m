From: "NeilBrown" <neilb@suse.de>
Subject: Re: can metadata type be changed for an active array?
Date: Fri, 27 Feb 2009 15:57:49 +1100 (EST)
Message-ID: <983bc6fdcd28a2885e2c5933dafc72eb.squirrel@neil.brown.name>
References: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: PGNet <pgnet.trash+raid@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, February 27, 2009 6:12 am, PGNet wrote:
> i've created an array,
>
>     mdadm --create /dev/md5 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
>
> checking,
>
> 	cat /proc/mdstat
> 	Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [linear]
> 	md5 : active raid1 sda2[0] sdb2[1]
> 		  341991616 blocks [2/2] [UU]
> 		  bitmap: 0/164 pages [0KB], 1024KB chunk
>
> i realized that it defaulted to metadata type = 0.90.
>
> is it possible to _modify_ this array to use "super 1.x" metadata
> type, rather than the default 0.90?
>
> neither 'manage' or 'grow' modes seem to allow it,
>
> 	mdadm --manage --metadata=1.2 /dev/md5
> 		mdadm:option --metadata not valid in manage mode
> 	mdadm --grow --metadata=1.2 /dev/md5
> 		mdadm:option --metadata not valid in grow mode

Yes and no....

There is no way to have mdadm convert the metadata (yet, maybe one day.
I accept patches).

However the 1.0 metadata uses less space than the 0.90 metadata so
it is fairly safe to simply stop the array and then create it with 1.0
metadata.  All your data will still be there.

The bitmap could get written at a different place, and could over-write
data.  So to be safe:

  mdadm -S /dev/md5
  mdadm -C /dev/md5 -l1 -n2  -e 1.0 -z  341991616 /dev/sda2 /dev/sdb2
--assume-clean

  # make sure your data looks right

  mdadm --grow /dev/md5 --bitmap=internal

Should be sufficient.

BTW, I doubt that I'll ever support online metadata conversion.
So the eventual command would be

  mdadm --assemble /dev/md5 --metadata=1.0 --update=metadata  /dev/sd[ab]2

or something like that.

NeilBrown


