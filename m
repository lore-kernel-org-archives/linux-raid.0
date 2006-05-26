From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 12:01:18 -0600
Message-ID: <1148666478.2836.53.camel@hendrix.hollabaugh.com>
References: <Pine.LNX.4.44.0605261327520.20378-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605261327520.20378-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-05-26 at 13:30 -0400, Mark Hahn wrote:
> yes - the kernel traditionally doesn't, of its own accord, read files.
> most stuff under /etc are inputs to user-level tools that run during 
> boot to instruct the kernel how to configure things.  distros have,
> in the past, had boot-time scripts that would run mdadm and thus 
> read your mdadm.conf (or the raid config files that predate mdadm...)
> 
> so perhaps your observed change in behavior had to do with distro changes...


I agree. There must have been a distro change over the past 3 years
concerning the array build process. I seem to remember a great concern
of mine to store my mdadm.conf off-site, just in case my rootfs drive
died (which it did of course). I also never set the partition types to
Linux raid either. So there's been a couple changes over the years,
probably more. 

I will say this. My 2 1TB 14 drive servers have been extremely reliable
for the past 3.5 years. Occasionally, I replace the power supply but
that's about it. Just for your information, a drive will drop out of the
array when the power supply starts to droop. When I have a drive
failure, I pull the drive, externally run a bad block test and replace
if necessary. If no errors, I replace the power supply and reinsert the
old drive back into the array and rebuild. This has happened about 5
times for my 2 servers over the past 3 years. 






> 
> 
-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com

