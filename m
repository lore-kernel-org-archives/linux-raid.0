From: maarten <maarten@ultratux.net>
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 22:17:29 +0100
Message-ID: <200501192217.29258.maarten@ultratux.net>
References: <20050117010355.GH347@unthought.net> <20050119195154.23514.qmail@web60405.mail.yahoo.com> <a0s2c2-7i2.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a0s2c2-7i2.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 19 January 2005 21:19, Peter T. Breuer wrote:
> Poonam Dalya <poonamsbox@yahoo.com> wrote:
> > I mounted my /dev/md1 on /mnt/raid. and then wrote a
> > file on it. Then I tried to mount the raid disks
> > /dev/hda10 on some other mount point and checked that
> > mount point. But there was nothing in that mount
> > point. Please could you please help me with this.

You did not forget to format / mkfs it I suppose ?

> Don't do that then. Do you have any reason to suppose that buffers were
> already written to the top level system yet, or that mounting the same
> device twice will caus eanything but pain and confusion and much
> wailing and gnashing of teeth?

Sigh.

> >        Sir I tried the same steps with a RAID1 array
>
> Don't.

Peter, peter peter.  You start again with nonsense and misinformation ?
Of course a disk from a raid-1 volume when mounted alone should have all the 
files accessible that the array has.  If it doesn't, the system is broken.  
Simple as that.

To the OP: Yes, every part of a raid-1 array (but only a raid-1 array) will / 
should be mountable and have the same filesystem as the array has.
HOWEVER you should never ever mount the array AT THE SAME TIME as one of its 
underlying devices!  Always umount first, and only then mount the other.

Maarten

-- 

