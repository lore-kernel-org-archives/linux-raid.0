From: David Taylor <davidt@yadt.co.uk>
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 14:19:47 +0000
Message-ID: <20131122141946.GA18625@yadt.co.uk>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <528A90B7.5010905@zytor.com>
 <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
 <528AA1EB.3010909@zytor.com>
 <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
 <528BCA2D.5010500@redhat.com>
 <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
 <528D61C5.70902@hardwarefreak.com>
 <528DCD36.1060808@hesbynett.no>
 <528F17FB.60909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528F17FB.60909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Nov 2013, Stan Hoeppner wrote:
>
> With
> any mirror based array one can lose half the disks as long as no two are
> in one mirror.  The probability of a pair failing together is very low,
> and this probability decreases even further as the number of drives in
> the array increases.  This is one of the many reasons RAID 10 has been
> so popular for so many years.

Er, no.

Sure, the probability of "the failed drive's pair" failing decreases
as the number of drives in the array increases IF you assume there will
be exactly one failure.

But adding more drives increases the probability of another drive
failure, and cancels that out.

Quite obviously adding more unrelated drives to an array does not
affect the probability of failure of the pre-existing drives!

(Except perhaps, by over-stressing the PSU and increasing the
chances of all the drives failing)

-- 
David Taylor 
