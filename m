From: Christian Mueller <christian.mueller1@gmx.de>
Subject: Re: raid1 boots with one disk only
Date: Fri, 04 Mar 2005 15:01:16 +0100
Message-ID: <42286A2C.9010206@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Steve!

How do you boot this beast (Bootloader)?
On what partition/md is actually /boot?


On 03.04.2005 12:03, Steve Kwee wrote:
> ..
> mdadm -E results in an error message complaining about a missing
> superblock (see 4.)
> ..
> -----------------------------
> 4.  mdadm -E /dev/md1
> -----------------------------
> mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got
> f1800828)
'man mdadm' shows the following

  -E, --examine
         Print content of md superblock on device(s).
                                           ^^^^^^^^^
So, this works not against an md array.


Cheers, Chris


-- 
# Christian Mueller                   email: <christian.mueller1@gmx.de>
#                                     phone: +49 6527 936129
#                                     @work: +49 6592 9691 15
#                                     mobil: +49 172 6769666



