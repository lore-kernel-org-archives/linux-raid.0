From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 15:45:23 +0000
Message-ID: <20110131154523.GF7861@cthulhu.home.robinhill.me.uk>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
 <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
 <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
 <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
 <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
 <AANLkTinOkzo2+ZO2fWHShOXPKE6ikQgo4LsOVpkdxHWq@mail.gmail.com>
 <AANLkTi=mWHz69_U1tWzyPGy3-drOA4T1-dHtu1OHLtA+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=mWHz69_U1tWzyPGy3-drOA4T1-dHtu1OHLtA+@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon Jan 31, 2011 at 01:32:06PM -0200, Roberto Spadim wrote:

> rewriting..
> using raid10 or raid01 you will have problems if you lose 2 drives too...
> if you lose two raid 1 devices you loose raid 1...
> see:
> 
> disks=4
> RAID 1+0
> raid1= 1-2(A)  ; 3-4(B); 5-6(C)
> raid0= A-B-C
> if you lose (A,B or C) your raid0 stop
> 
> RAID 0+1
> raid0= 1-2-3(A)  ; 4-5-6(B)
> raid1= A-B
> if you lose (1,4 OR 1,5 OR 1,6 OR 2,4 OR 2,5 OR 2,6 OR 3,4 OR 4,5 OR
> 4,6) your raid0 stop
> 
> using raid1+0 or raid0+1 you can't lose two disks...
> 
Yes you can - it just depends which disks. With the 6-disk case you can
lose a maximum of 3 drives, though only a single drive failure will
definitely not cause total array failure.  For RAID1+0 your 2-drive
failure cases are only 1,2 OR 3,4 OR 5,6 - any other pairing will not
break the overall array.  For RAID0+1 there's 9 failure cases as you
point out (except the last two should be 3,5 and 3,6).

Cheers,
    Robin
