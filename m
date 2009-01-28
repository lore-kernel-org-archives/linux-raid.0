From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Wed, 28 Jan 2009 17:31:48 -0500
Message-ID: <4980DCD4.3040605@tmr.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233174633.7008.34.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vladimir Ivashchenko wrote:
> Hi,
>
> We've got these new Sun X4500 servers. The system I'm playing with now
> has 48 x 250 GB SATA HDDs.
>
> Right now I'm creating two RAID6 arrays, 24 and 22 drives each:
>
> mdadm --verbose --create /dev/md3 --level=6
> --raid-devices=24 /dev/sda /dev/sdaa /dev/sdab /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas /dev/sdat /dev/sdau /dev/sdav /dev/sdb /dev/sdc
>
> mdadm --verbose --create /dev/md4 --level=6
> --raid-devices=22 /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdz
>
> mdadm --detail is reporting that everything is going smoothly, however
> my /var/log/messages is full of "BUG: soft lockup - CPU#X stuck for
> 10s!" errors appearing every 1-3 minutes. 
>
> CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
> Ghz, 16 GB RAM.
>
> The system does not crash and otherwise seems to be healthy. Arrays are
> still under construction and I don't know if they will actually work
> yet.
>
> What I noticed is that at first it was complaining about lockups on md3
> process, but once I started creating md4, complaints were exclusively
> for md4 process only.
>
> Any stability assurances or workarounds are highly appreciated. :)
>   

Recently comments about soft lockups in md init have popped up on 
several lists, and the consensus seems to be that some of the internal 
operations are keeping one or more CPUs waiting, but that's not a 
failure. I'm guessing that a more recent kernel might not do this, but 
it probably doesn't indicate a functional problem.

My read on a newer kernel is this:
- you went with CentOS instead of Fedora, you got stable instead of 
cutting edge
- CentOS 5.3 is coming out soon, RHEL 5.3 just came out
- it's not a functional problem

I'm planning to go to CentOS 5.3 on some machines, and I run Fedora on 
the rest. I don't see any joy between "most recent" and "most stable" on 
my systems. I would ignore the warning unless it happens during normal 
operation.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


