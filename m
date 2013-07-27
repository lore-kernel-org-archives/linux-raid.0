From: Wes <wt75@gazeta.pl>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Sat, 27 Jul 2013 20:22:48 +0000 (UTC)
Message-ID: <loom.20130727T221553-552@post.gmane.org>
References: <loom.20130725T120703-146@post.gmane.org> <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike <at> swm.pp.se> writes:

> Does seekmark use barriers to assure that data has actually been written? 
> In that case it could be that 2.6.18 has different behaviour from 2.6.32 
> when it comes to barriers and that explains the speed difference.
>



Mikael, looks like you were right.

Aside from seekmark I was also testing with random dd to not relay on single
measurment tool.
 
I run found out it is not only related to raid but to block devices in
general. I run 'hdparm -W0 /dev/sda' on cetos5 and got the same poor
behavior of centos6.

Anyway I cannot still find a way to enable drive write cache on centos6.
hdparm reports it is enabled but results are the same (poor) no matter
if after 'hdparm -W0 /dev/sda' or 'hdparm -W1 /dev/sda' so now I am guessing
write cache must be blocked somewhere in the kernel.

I still cannot find a way to enable write cache in centos 6.
Booting with 'barriers=off' kernel parameter and 'barrier=0' in fstab does
not help.
 




