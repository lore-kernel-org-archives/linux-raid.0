From: Maarten J H van den Berg <maarten@vbvb.nl>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 3 Mar 2004 02:11:35 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403030211.35753.maarten@vbvb.nl>
References: <4045288B.27321.2DA4EF3@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4045288B.27321.2DA4EF3@localhost>
Content-Disposition: inline
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 03 March 2004 01:36, Chris Evans wrote:
> On 3 Mar 2004 at 10:40, Neil Brown wrote:
> > Wrong.
> >  mkfs -t ext3 /dev/md0
> > then mount /dev/md0.
> > Once you have included /dev/hdc1 in an array, don't touch it again -
> > just access the array (/dev/md0).
>
> Sorry, I was being hasty in writing the Email, that's what I did,
> i.e. mkfs the /dev/md0 drive.  That's not the problem.

Hope it's not too obvious, but...
Did you also actually _run_ lilo ?  
Is fstab on /dev/md0 edited to reflect the new mountpoints ?

Not that it helps you here, but I followed the procedure -albeit not from the 
same howto[1]- multiple times with many machines. It _should_ work...

  [1] I used a howto by the name of Boot+root+raid+llilo. Maybe see if there
   are any obvious differences between the two procedures / howtos...?  

Maarten

