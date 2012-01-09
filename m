From: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Subject: Re: raid 1 bug with write-mostly and administrative failed disk
Date: Mon, 9 Jan 2012 14:25:16 +0100
Message-ID: <20120109132516.GG3692@telegraafnet.nl>
References: <20120109123552.4a5f44de@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120109123552.4a5f44de@notabene.brown>
 <20120109123403.1286fd36@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Mon, Jan 09, 2012 at 12:34:03PM +1100, NeilBrown wrote:
> On Thu, 5 Jan 2012 22:30:23 +0100 Art -kwaak- van Breemen
> <ard@telegraafnet.nl> wrote:
> 
> > Anyway: I found a small bug in raid1, with write-behind and
> > write-mostly, occuring at least on 3.1.4 and 3.2 .
>
> I never tested write-behind :-(

Well, I (un?)fortunately had a testcase were I was exchanging disks from a raid
array for ssd.

> Please confirm that this patch fixes it for you.

My latest testcase:
mdadm --create -l 1 -n 2 --bitmap=internal /dev/md3 -W /dev/sdb6 /dev/sda6
works like a charm now for 3.2 :-).

Proof:
md3 : active raid1 sda6[1](W) sdb6[0](W)
      2103478 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

Failing disk 1 and then reading it works.

Thanks Neil! I can be very happy now (3.1 is a very stable
series so I guess 3.2 is stable too :-) ).
But trying to understand the patch: we have selected a disk but we
did not have determined the amount of readable sectors on that
disk so it defaulted to 0?

Thanks again!
Regards,
Ard van Breemen
