From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Thu, 20 Oct 2005 12:41:17 +0100
Message-ID: <dj7vou$o56$1@sea.gmane.org>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net> <43577022.5010306@robinbowes.com> <20051020111943.GA9757@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051020111943.GA9757@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gregory Seidman said the following on 20/10/2005 12:19:
> } PV:
> } /dev/md1 - 4 x 40GB drives (RAID5 - 120GB total)
> } /dev/md2 - 4 x 40GB drives (RAID5 - 120GB total)
> 
> You should at least read the following before using RAID5. You can agree or
> disagree, but you should take the arguments into account:
> 
> http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt

This was just an example configuration. My current 1TB array is RAID5 
with 1 hot spare but I'll most likely use RAID6 in production.


> } Suppose I then add a new PV:
> } /dev/md3 - 4 x 300GB drives (RAID5 - 900GB total)
> 
> You use pvcreate and vgextend to do so, incidentally.

Yes, thanks for the detail.

> } When this finishes, big_vg will contain /dev/md2 + /dev/md3 (1020GB 
> } total). /dev/md1 will be unused.
> 
> /dev/md1 will still be a part of big_vg, but it won't have any data from
> any LVs on it. You will need to use vgreduce to remove /dev/md1 from the
> VG:
> 
> # vgreduce big_vg /dev/md1

Ah, yes, forgot about that step.

Thanks for the validation of the methodology.

I'm going to give this a try on my test server (using much smaller disks!)

Thanks again,

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?

