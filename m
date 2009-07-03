From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID6 questions
Date: Fri, 3 Jul 2009 08:40:03 +0200
Message-ID: <20090703064003.GC23464@maude.comedia.it>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 02, 2009 at 05:22:54PM +0200, Marek wrote:
>5. In case one decides for a partitioned approach - does mdadm kick
>out faulty partitions or whole drives? I have read several sources
>including some comments on slashdot that it's much better to split
>large drives into many small partitions, but noone clarified in
maybe because those suggesting this are not able to come up with a
reasonable explanation?
>detail.  A possible though unlikely scenario would be simultaneous
>failure of all hdds in the array:
>
> md1 RAID6 sda1[_] sdb1[_] sdc1[U] sdd1[U] sde1[U] sdf1[U]
> md2 RAID6 sda2[U] sdb2[_] sdc2[_] sdd2[U] sde2[U] sdf2[U]
> md3 RAID6 sda3[U] sdb3[U] sdc3[_] sdd3[_] sde3[U] sdf3[U]
> md4 RAID6 sda4[U] sdb4[U] sdc4[U] sdd4[_] sde4[_] sdf4[U]
> md5 RAID6 sda5[U] sdb5[U] sdc5[U] sdd5[U] sde5[_] sdf5[_]
>(...)
>
>If mdadm kicks out faulty partitions only, but leaves the remaining
>part of drive going as long as it's able to read it, would it mean
>that even if every single hdd in the array failed somewhere (for
>example due to Reallocated_Sector_Ct), mdadm would keep the healthy
>partitions of that failed drive running, thus the entire system would
>be still running in degraded mode without loss of data?
This really depends on your priorities, i would have replaced my drives
well in advance of a similar situation.
The only reason i can imagine for splitting a disk into many partitions
and raiding them together is avoiding lenghty rebuilds when a single
drive is kicked from an array due to a correctable read error.
In practice the above scenario should not happen anymore, since md will
retry writing a stripe if it gets a read-error, besides you are planning
on using raid6, so a single drive failure will still leave you with a
nice degree of protection.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
