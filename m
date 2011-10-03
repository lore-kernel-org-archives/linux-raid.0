From: Joe Landman <joe.landman@gmail.com>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 10:24:00 -0400
Message-ID: <4E89C580.8050603@gmail.com>
References: <4E89B81D.5000800@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89B81D.5000800@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/03/2011 09:26 AM, Marcin M. Jessa wrote:

> The load seemed to have stressed my array/the HDs to the point when 3 of
> the drives were kicked off the array resulting in loss of data.

Hmmm .... this sounds like hardware failure.

> It's hard to find a cause of it - some forum threads on the Interner
> suggest it may be the kernel, some say it could be the SATA controller,
> the SATA cables and most of them suggest it's because of the hard drives.

What SATA controller?  If its a Marvell, you have your answer.  What 
CPU, etc. , how much ram, what motherboard, bios revs, etc. ?  Is this a 
motherboard SATA, or a PCI card SATA?  Could you send dmidecode output, 
and possibly dmesg output (or post them on pastebin)?

Assume that you have one (or more) possibly broken (irreparably so) 
hardware devices in your path that "high" loads tickle in just the right 
manner ... substandard or broken hardware will in fact behave exactly 
the way you describe.

Note:  could be IRQ routing, or PCI silliness, or other joyous things 
(we've run into many such problems).  But as often as not, this is a 
symptom of one hardware element that is beyond hope.

>
> Now I would like to stress test the array and see whether it would fail
> again or not. What would be the best way to do that?

We built a simple looping checkout code atop fio 
(http://git.kernel.dk/?p=fio.git;a=summary  if you are not using fio, 
you should be, Jens Axboe has done an absolutely wonderful job with it).

Our perl driver and input deck are here:

	http://download.scalableinformatics.com/disk_stress_tests/fio/

To use them, pull both down, make the loop_check.pl executable, and make 
sure fio is in your path.  Edit the sw_check.fio to change the 
directory=/data to point to your raid mount point (assuming its mounted 
with a file system atop it).  Run it like this

	nohup ./loop_check.pl 10 > out 2>&1 &

which will execute the fio against sw_check.fio 10 times.  Each 
sw_check.fio run will write and check 512GB of data (4 jobs, each 
writing and checking 128 GB data).  Go ahead and change that if you 
want.  We use a test just like this in our system checkout pipeline.

This *will* stress all aspects of your units very hard.  If you have an 
error in your paths, you will see crc errors in the output.  If you have 
a marginal RAID system, this will probably kill it.  Which is good, as 
you'd much rather it die on a hard test like this than in production.

You can ramp up the intensity by increasing the number of jobs, or the 
size of the io, etc.  We can (and do) crash machines with horrific loads 
generated from similar tests, just to see where the limits of the 
machines are at, and to help us tweak/tune our kernels for best 
stability under these horrific loads.  The base test is used to convince 
us that the RAID is stable though.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
