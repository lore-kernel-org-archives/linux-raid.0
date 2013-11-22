From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 02:38:19 -0600
Message-ID: <528F17FB.60909@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528DCD36.1060808@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

On 11/21/2013 3:07 AM, David Brown wrote:

> For example, with 20 disks at 1 TB each, you can have:

All correct, and these are maximum redundancies.

Maximum:

> raid5 = 19TB, 1 disk redundancy
> raid6 = 18TB, 2 disk redundancy
> raid6.3 = 17TB, 3 disk redundancy
> raid6.4 = 16TB, 4 disk redundancy
> raid6.5 = 15TB, 5 disk redundancy


These are not fully correct, because only the minimums are stated.  With
any mirror based array one can lose half the disks as long as no two are
in one mirror.  The probability of a pair failing together is very low,
and this probability decreases even further as the number of drives in
the array increases.  This is one of the many reasons RAID 10 has been
so popular for so many years.

Minimum:

> raid10 = 10TB, 1 disk redundancy
> raid15 = 8TB, 3 disk redundancy
> raid16 = 6TB, 5 disk redundancy

Maximum:

RAID 10 = 10 disk redundancy
RAID 15 = 11 disk redundancy
RAID 16 = 12 disk redundancy

Range:

RAID 10 = 1-10 disk redundancy
RAID 15 = 3-11 disk redundancy
RAID 16 = 5-12 disk redundancy


-- 
Stan
