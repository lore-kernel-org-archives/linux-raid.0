From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sat, 16 Feb 2013 01:32:18 +1100
Message-ID: <c0057008-8681-4275-a6e2-e747c9711158@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.and
 roid.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511E38C7.6000203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:

>On 2/14/2013 6:22 AM, Stan Hoeppner wrote:
>
>> Then create 8 table entries with names, such as port_0 thru port_7:
>> 
>> ~$ echo 100 port_0 >> /etc/iproute2/rt_tables
>> ......
>> ~$ echo 101 port_7 >> /etc/iproute2/rt_tables
>
>Correcting a typo here, this 2nd line above should read:
>
>~$ echo 107 port_7 >> /etc/iproute2/rt_tables

Thank you for that, I wasn't too sure I trusted your suggestion so I did go and do some research including reading the sysctl information you pasted, and it sounded correct... so, should be good :)

>** IMPORTANT **
>All of the work you've done with iscsiadm to this point has been with
>clients having a single iSCSI ethernet port and single server target
>port, and everything "just worked" without specifying local and target
>addresses (BTW, don't use the server hostname for any of these
>operations, obviously, only the IP addresses as they won't map).  Since
>you will now have two local iSCSI addresses and potentially 8 target
>addresses, discovery and possibly operations should probably be done on
>a 1:1 port basis to make sure both client ports are working and both
>are
>logging into the correct remote ports and mapping the correct LUNs.
>Executing the same shell command 128 times across 8 hosts, changing
>source and port IP addresses each time, seems susceptible to input
>errors.  Two per host less so.

Hmmm, 8 SAN IP's x 2 interfaces x 8 machines is a total of 128, or only 16 times on each machine. Personally, it sounds like the perfect case of scripting :)

However, another downside is that if I add another 8 IP's on the secondary san, I have 16 SAN IP's x 2 interfaces x 8 machines, or 256 entries. However, I think linux MPIO has a max of 8 paths anyway, so I was going to have to cull this down I suspect.

>On paper, if multipath will fan all 8 remote ports from each client
>port, theoretically you could getter better utilization in some client
>access pattern scenarios.  But in real world use, you won't see a
>difference.  Given the complexity of trying to use all 8 server ports
>per client port, if this was my network, I'd do it like this,
>conceptually:  http://www.hardwarefreak.com/lun-mapping.png
>Going the "all 8" route you'd add another 112 lines to that diagram
>atop
>the current 16.  That seems a little "busy" and unnecessary, more
>difficult to troubleshoot.

The downside to your suggestion is that if machine 1 and 5 are both busy at the same time, they only get 1Gbps each. Keep the vertical paths as is, but change the second path to an offset of only 1 (or 2 or 3 would work, just not 4), then there are no pair of hosts sharing both ports, so two machines busy can still get 1.5Gbps.... 

>Yes, I originally suggested fanning across all 8 ports, but after
>weighing the marginal potential benefit against the many negatives,
>it's clear to me that it's not the way to go.
>
>So during your next trip to the client, once you have all of your new
>cables and ties, it should be relatively quick to set this up.  Going
>the "all 8" route maybe not so quick.

I'm still considering the option of configuring the SAN server with two groups of 4 ports in a balance-alb bond, then the clients only need MPIO from two ports to two SAN IP's, or 4 paths each, plus the bond will manage the traffic balancing at the SAN server side across any two ports..... I can even lose the source based routing if I use different subnets and different VLAN's, and ignore the arp issues all around. I think that and your solution above are mostly equal, but I'll try the suggestion above first, if I get stuck, this would be my fallback plan.... 

I really need to get this done by Monday after today (one terminal server was offline for 30 minutes, you would think that was the end of the world....I thought 30 minutes was pretty good, since it took 20 minutes for them to tell me........).

So, I'll let you know how it goes, and hopefully show off some flashy pictures to boot, and then next week will be the real test from the users...

PS, the once a week backup process person advised that the backup on thursday night was 10% faster than normal... So that was a promising sign.


Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
