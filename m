From: "John Stoffel" <john@stoffel.org>
Subject: Re: Fwd: I will pay money for the correct RAID recovery instructions
Date: Fri, 17 Oct 2014 12:14:03 -0400
Message-ID: <21569.16459.69850.406372@quad.stoffel.home>
References: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
	<20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
	<CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
	<21569.8756.823611.71332@quad.stoffel.home>
	<CAOS+5GGMGU2doP=v1LfeA5CDDmuMj4gxUcNtoK5-gJWHO9CMaw@mail.gmail.com>
	<CAOS+5GEbNPAWfBL_uPDOuhMb4LtN+_fJ07MD7igOQmVi04mWpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEbNPAWfBL_uPDOuhMb4LtN+_fJ07MD7igOQmVi04mWpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Another> Sorry to state the obvious but......  To restore the degraded
Another> array would (based on the info you've posted) likely take
Another> longer then temporarily moving the data to a different set of
Another> drives.

How do you figure this?  He hasn't posted any useful data on his array
at all.  We know it's six 3Tb disks in RAID10, so that's at most 9Tb
of data.  Moving 3Tb (bad disk ddrescue'd onto new disk) is only 3Tb
to move.  Then the resync will of course take time.  

But if he doesn't have the spare disk space, it's probably the only way.

Another> As time seems to be a major consideration here (likely/possible
Another> failure of sde) then surely the optimal strategy has to be to get the
Another> data off first, then look at the rebuilding the degraded array?

Another> Just my 2c

Another> On 17 October 2014 15:05, John Stoffel <john@stoffel.org> wrote:
>> 
>> 
>> Ian,
>> 
>> It would also help if you posted the details of your setup using:
>> 
>> cat /proc/partitions
>> cat /proc/mdstat
>> 
>> mdadm -D /dev/md#
>> - for each of the devices above.
>> 
>> mdadm -E /dev/sd<drive><#>
>> - for each disk or partition in the array from above.
>> 
>> 
>> 
>> But the suggestions to ddrescue the going bad drive onto a new disk is
>> a good one.  On my debian system, I would do the following:
>> 
>> sudo apt-get install gddrescue
>> ddrescue /dev/sde /dev/sdf /var/tmp/ddrecue-sde.log
>> 
>> and see how that goes.
>> 
>> Good luck,
>> John
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Another> --
Another> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Another> the body of a message to majordomo@vger.kernel.org
Another> More majordomo info at  http://vger.kernel.org/majordomo-info.html
