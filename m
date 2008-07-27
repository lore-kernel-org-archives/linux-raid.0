From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: Problem with mdadm 2.6.7
Date: Sun, 27 Jul 2008 18:24:24 +0300
Message-ID: <488C9328.8010503@mandriva.org>
References: <488C531B.5060005@mandriva.org>  <488C8599.4090503@mandriva.org> <1217171198.9041.62.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217171198.9041.62.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford skrev:
> On Sun, 2008-07-27 at 17:26 +0300, Thomas Backlund wrote:
>> Hi,
>> (please cc me as I'm not subscribed)
>>
>> I have hit a bug with mdadm 2.6.7
>>
>> It rebuilds my raid5 array on every boot
>> (raid0 and raid1 arrays are not affected)
>>
>> This didn't happend with 2.6.4
>>
>> kernels tested are 2.6.24.7 and 2.6.25.12
>>
>> Arch is x86_64
>> Distro Mandriva 2008.1, but I've tested wich kernel.org kernels and 
>> upstream mdadm 2.6.7 and have the same problem
>>
>> Now I could try to bisect it, but every raid5 rebuild takes 6-7 hours, 
>> so I thought about asking for pointers before...
>>
>> Any ideas where to start looking ?
> 
> Are you using mkinitrd (or something similar) to start the arrays, or
> are you using udev rules that call mdadm --incremental --run?  If it's
> the later, then this is what you get when A) the array is started as
> soon as there are enough devices to run in degraded mode and B)
> something writes to the array before the last device gets added and C)
> you don't have a bitmap to allow the array to keep track of what blocks
> need resynced and therefore it resynces the entire drive.
> 

I'm using udev.

but looking at the difference between 2.6.4 and 2.6.7:

diff -Nurp mdadm-2.6.4/etc/udev/rules.d/70-mdadm.rules 
mdadm-2.6.7/etc/udev/rules.d/70-mdadm.rules
--- mdadm-2.6.4/etc/udev/rules.d/70-mdadm.rules	2008-07-27 
13:14:10.000000000 +0300
+++ mdadm-2.6.7/etc/udev/rules.d/70-mdadm.rules	2008-07-27 
13:11:13.000000000 +0300
@@ -3,4 +3,4 @@
  # See udev(8) for syntax

  SUBSYSTEM=="block", ACTION=="add|change", 
ENV{ID_FS_TYPE}=="linux_raid*", \
-	RUN+="/sbin/mdadm --incremental $root/%k"
+	RUN+="/sbin/mdadm --incremental --run --scan $root/%k"


I see that --incremental was already there in 2.6.4, so I guess the 
--run is the one messing with me...




as for --bitmap, can it be added to an existing array ?

What is the better choice, bitmap=internal or bitmap=<some_file> ?

I'd hate to have to recreate the array, as I have about 1.2GB of data on 
it...

--
Thomas
