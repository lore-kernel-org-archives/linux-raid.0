From: Another Sillyname <anothersname@googlemail.com>
Subject: Fwd: I will pay money for the correct RAID recovery instructions
Date: Fri, 17 Oct 2014 16:13:21 +0100
Message-ID: <CAOS+5GEbNPAWfBL_uPDOuhMb4LtN+_fJ07MD7igOQmVi04mWpA@mail.gmail.com>
References: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
	<20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
	<CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
	<21569.8756.823611.71332@quad.stoffel.home>
	<CAOS+5GGMGU2doP=v1LfeA5CDDmuMj4gxUcNtoK5-gJWHO9CMaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GGMGU2doP=v1LfeA5CDDmuMj4gxUcNtoK5-gJWHO9CMaw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry to state the obvious but......

To restore the degraded array would (based on the info you've posted)
likely take longer then temporarily moving the data to a different set
of drives.

As time seems to be a major consideration here (likely/possible
failure of sde) then surely the optimal strategy has to be to get the
data off first, then look at the rebuilding the degraded array?

Just my 2c

On 17 October 2014 15:05, John Stoffel <john@stoffel.org> wrote:
>
>
> Ian,
>
> It would also help if you posted the details of your setup using:
>
> cat /proc/partitions
> cat /proc/mdstat
>
> mdadm -D /dev/md#
>  - for each of the devices above.
>
> mdadm -E /dev/sd<drive><#>
>  - for each disk or partition in the array from above.
>
>
>
> But the suggestions to ddrescue the going bad drive onto a new disk is
> a good one.  On my debian system, I would do the following:
>
>   sudo apt-get install gddrescue
>   ddrescue /dev/sde /dev/sdf /var/tmp/ddrecue-sde.log
>
> and see how that goes.
>
> Good luck,
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
