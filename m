From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Tue, 18 Nov 2003 09:29:30 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16313.19402.432049.249742@notabene.cse.unsw.edu.au>
References: <3FB75992.3020608@bnap.hu>
	<20031117092922.GD30745@percy.comedia.it>
	<16312.39435.330127.598268@notabene.cse.unsw.edu.au>
	<3FB8D5A6.4040909@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Monday November 17
To: Farkas Levente <lfarkas@bnap.hu>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 17, lfarkas@bnap.hu wrote:
> this's one of our production server, so I'd like to be sure. so:
> - switch the disk one by one (do these steps 8 times):
>    - put out one 120 hd (mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1)

I would do this as two separate steps
   mdadm /dev/md0 -f /dev/sda1
   mdadm /dev/md0 -r /dev/sda1

as there are some possibly race problems when removing a device the
instant that it failes.

>    - put the new 200 GB one and create a 200 GB partition (Linux raid
>      autodetect)
>    - add to md0 (mdadm -a /dev/hda1) this step do not change the device
>      order???

No, it shouldnt' but it shouldn't matter.

> - resize2fs
> 
> when should I use --force??

When you have the array full of 200GB drives, use
  mdadm -D /dev/md0
to find out what it looks like.  This will include algorithm, chunk
size, etc.  Keep a copy of the output.
Then 
   mdadm -S /dev/md0

It probably would be to use the "missing" directive as Luca
suggested.  This will create a degraded array and so will not
automatically regenerate any data.  

Something like:
mdadm -C /dev/md0 --level 5 -n 8 --chunk=64 /dev/sda1 /dev/sdb1 /dev/sdc1
    .... /dev/sdf1 /dev/sdg1 missing

If you do this, it will only over-write the raid superblocks and will
not touch the data.

You can then
   fsck -n /dev/md0
just to make sure it looks right (you don't have to let this run to
completion. Just let it run for a new minutes to make sure nothing
obvious is wrong) Then mount the filesystem and have a look around.
If everything is OK, unmount and try resize2fs.

When you are happy the the array looks good, add the last drive back
in with
   mdadm /dev/md0 -a /dev/sdh1

NeilBrown
