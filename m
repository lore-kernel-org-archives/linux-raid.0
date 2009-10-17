From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: best practice when using removable drives and USB enclosure?
Date: Sat, 17 Oct 2009 12:09:49 -0700
Message-ID: <2267211f0910171209u1ec7987dq67405f4b3bb780c0@mail.gmail.com>
References: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
	<4ADA11F8.90000@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ADA11F8.90000@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for the help.


>>You should be aware that using external disks through USB means that
>>SMART tools can't monitor your disks for bad sectors and read errors,
>>thus if any occur you won't know till you start getting I/O errors --
>>it would be almost too late by then.

Yes, this is a major sticking point.  I am doing backups of this USB
RAID1 array offline, but I'd like to get SMART status.  Long term I
see this going into an eSATA enclosure.  Just need to find reasonable
card supporting port multipliers and a good port multiplier.


>>Just remove the devices= entry; it is redundent when you are using UUID's.

Gotcha, tried this and I'm still having issues with md1 being assembled on boot.

It looks like what I'm running into now is that mdadm is assembling
the arrays before the USB drives are initialized so the drives aren't
available until the USB module is initialized.  I'm running Fedora 11
- I think I need to modify my boot time options to either have USB
brought up earlier or mdadm assemble arrays later in the boot time.
I'm not using RAID on any boot partitions so I don't necessarily need
arrays early.


-- 
-tim
