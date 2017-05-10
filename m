From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Network based (iSCSI) RAID1 setup
Date: Wed, 10 May 2017 22:08:07 +1000
Message-ID: <651c37fe-68b2-2dd7-a429-e62c994de60b@websitemanagers.com.au>
References: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/5/17 18:42, Gionatan Danti wrote:
> Hi all,
> I'm trying to understand if, and how, mdadm can be used with network 
> attached devices (iSCSI, in this case). I have a very simple setup 
> with two 1 GB drives, the first being a local disk (a logical volume, 
> really) and the second a remote iSCSI disk.
>
> First question: even if in my preliminary tests this seems to work 
> reasonably well, do you feel that such solution can be used for 
> production workloads? Or something with a more specific focus, as 
> DRBD, remains the preferred solution?
>
It depends on your definition of production, but for me, the answer is 
no. Once upon a time, I used MD to do RAID1 between a local SSD and a 
remote device with NBD and that worked well, (apart from the fact I 
needed to manually re-add the remote device after a reboot, or whenever 
it dropped out for any other reason). It did save me when the local SSD 
died, and I was able to keep running purely from the remote NBD device 
until I could get in and replace the local SSD.

Today, I use DRBD, and would much prefer that compared to MD + NBD.
> I'm using two CentOS 7.3 x86-64 boxes, with kernel version 
> 3.10.0-514.16.1.el7.x86_64 and mdadm v3.4 - 28th January 2016. Here 
> you can find my current RAID1 setup, where /dev/sdb is the iSCSI disk:
>
> So, second question: how to enable auto re-add for the remote device 
> when it become available again? For example:

I don't know, but I guess you need to work out what udev rules are 
triggered when the iscsi device is "connected", and then get that to 
trigger the MD add rules. Possibly you could try to create a partition 
on the iscsi, and then use sdb1 for the RAID array, there might be 
better handling by udev in that case (I really don't know, just making 
random suggestions here).
> Even if /dev/sdb is now visible, it is not auto re-added to the array. 
> If I run mdadm /dev/sdb --incremental --run I see the device added as 
> a spare:
>
> [root@gdanti-laptop g.danti]# cat /proc/mdstat
> Personalities : [raid1]
> md200 : active (auto-read-only) raid1 sdb[1](S) dm-3[0]
>       1047552 blocks super 1.2 [2/1] [U_]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> unused devices: <none>
>
> Third question: with --incremental adds device as a spare, rather than 
> active?
>
Is it because the raid isn't actually running? Perhaps you need to start 
the array first?
> I've looked at the POLICY directive in mdadm.conf, but I am unable to 
> make it work by auto re-adding iSCSI devices when they become up again.
I'd suggest using DRBD, it handles all these things a lot better because 
it is normal events for it, and a lot more people will be able to assist 
when something goes wrong with it.

Regards,
Adam
