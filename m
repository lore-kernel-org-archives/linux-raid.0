From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUGREPORT: mdadm v2.0-devel - Examine and zero-superblock misbehaving
Date: Wed, 4 May 2005 09:50:06 +1000
Message-ID: <17016.3630.940288.540120@cse.unsw.edu.au>
References: <42775A61.6020708@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 3, pml@dtbb.net wrote:
> On a site note, mdadm --zero-superblock doesn't seem to work correctly 
> with mdadm v2.0-devel, it reports no error when you use it, but you can 
> mdadm -E /dev/hdX after using it, and there is still a superblock, if 
> you use mdadm v1.9.0-2, it works correctly, and the examine shows 
> nothing afterwards.  Examples follow after the first problem.  Mdadm 
> v2.0 also seems to misreport the findings using the examine function.. 
> "381 spares."  Using kernel 2.6.12-rc3-mm2.
> 
> First i run zero superblock with mdadm v2.0-devel from current dir:
> 
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc
> 
> Then examine the superblock using mdadm v2.0-devel from current dir:
> 
> root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
> /dev/hdc:
>           Magic : a92b4efc
>         Version : 01.00

What has happened here is that "mdadm --zero-superblock" found a
version 0.90 superblock and zeroed it.  There was still a version 1
superblock (which lives in a different location). and -E found that.
If you run --zero-superblock serveral times it should zero everything,
though normally you would not expect to have multiple superblocks.

> 
>    Array State : Uuu 381 spares
> 

Not sure about this.  I'll have to spend  a while reminding my self
what is meant to happen, and what actually does...

NeilBrown
