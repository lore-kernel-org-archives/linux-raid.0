From: Russell Coker <russell@coker.com.au>
Subject: Re: Triple parity and beyond
Date: Thu, 28 Nov 2013 18:36:56 +1100
Message-ID: <201311281836.56235.russell@coker.com.au>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528F5AF4.60803@hesbynett.no> <5296EDBD.8030905@hardwarefreak.com>
Reply-To: russell@coker.com.au
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5296EDBD.8030905@hardwarefreak.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Nov 2013, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> We must follow different definitions of "redundancy".  I view redundancy
> as the number of drives that can fail without taking down the array.  In
> the case of the above 20 drive RAID15 that maximum is clearly 11
> drives-- one of every mirror and both of one mirror can fail.  The 12th
> drive failure kills the array.

It seems to me that the more useful number is how many disks can randomly die 
while there is a guarantee that no data is lost.  While with a 20 disk RAID-15 
you could get really lucky and have it still work after 11 disks have been 
lost you could lose it all after 4 disks have been lost.  Given that drive 
failures won't be entirely random (when one disk dies it puts more load on 
it's mirror) having a 20 disk RAID-15 entirely fail after 4 or 5 disk failures 
is probably more likely than having it keep working after 11 failures.

But as far as I can determine in the 20 disk RAID-15 array in question the 
"redundancy" would be 11 disks because once you have lost that many disks the 
usable capacity would be equal to the number of running disks multiplied by 
their capacity.

For simpler RAID configurations the "redundancy" equals the maximum number of 
disks that can randomly fail without losing any data while with nested RAIDs 
that's not the case.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
