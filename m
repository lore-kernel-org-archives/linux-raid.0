From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Adding a mirror to a RAID1 Device
Date: Tue, 25 Nov 2003 18:21:00 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16323.732.390200.935640@notabene.cse.unsw.edu.au>
References: <S262074AbTKYGHX/20031125060723Z+10693@vger.kernel.org>
	<63168.209.233.26.53.1069741184.squirrel@sampson.crome.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Caleb Crome on Monday November 24
To: Caleb Crome <linux-raid@crome.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 24, linux-raid@crome.org wrote:
> Hello all, I've got a peculiar problem.  I added some new disk space to my
> system (Linux 2.4.19, Mandrake), and created a RAID1 drive /dev/md0 with
> only 1 active mirror because I didn't have enough space (yet) to put
> everything on my new raid drive.  I had the intention of then addeding
> another disk to the raid setup later so that it would just
> auto-reconsctruct and be ready to go.

Sorry, but that was the wrong thing to do.
A raid1 with only one drive is pretty pointless, but you asked for it
and you got it :-)

What you should have done is make a raid1 with 2 drives, one of which
was missing/failed.  With mdadm, the command would be:

  mdadm -C /dev/md0 --level=raid1 --disks=2 /dev/hda3 missing

then you can hot-add the extra drive when it arrives.

What you have to do now is recreate the raid1 with two drives.  You
will have to have the filesystem unmounted and the raid stopped, but
you will not lose any data.

NeilBrown
