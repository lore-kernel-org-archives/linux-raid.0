From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 14 Feb 2013 07:20:27 +1100
Message-ID: <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, it's 7am, and I'm still here.... It all didn't go as well as I had planned....

I initially could ping perfectly from either of the two IP's on the xen box to any of the 8 IP's on the san1, even ping -f worked perfectly. Whatever I did, I couldn't get a iscsiadm .... discover to work... I could see the packets being sent from the san box (tcpdump) but never received by the xen box.

Eventually I pulled the disabled all except one ethernet device on both machines, still no luck. Finally, out of desperation I pulled the cables from both machines, dropped in a direct cable (ie, bypass the nice shiny new switch), and discover worked immediately. So I tried with the old switch, but same problem, so I've now connected each xen box direct to san1 ethernet port, so they now all get a dedicated 1 Gbps port each.

I think the problem with the switch is that I didn't configure it properly to support the 9000 MTU, or something like that, which now makes more sense that lots of small packets are fine (not faulty cables, network cards, switches, etc) but big packets fail (like the response to a DiscoveryAll packet).

Anyway, all systems are online, and I think I will leave things as is for now.

What I have accomplished:
1) All systems should be using dedicated 1Gbps for iSCSI and 1Gbps for everything else
2) All hardware is physically installed

What I think I need next time
1) 10 x colour coded 2m cables (management/user LAN ports), probably blue to match all the rest of the user cabling
2) 8 cables in green (port 1 xen)
3) 8 cables in yellow (port 2 xen)
4) 8 cables in white (4 each for san1/san2 on 1st card)
5) 8 cables in grey (4 each for san1/san2 on 2nd card)
6) Lotsa cable ties to keep each bundle together

Don't really know what colour cables are available, or even sure if it is such a good idea to use so many different colours.... Another option would be to stick with two colours, one for the iSCSI SAN network, and the second colour for the user LAN. Just makes it hard trying to work out which port/machine the other end of this random cable is connected to.....

Anyway, monitoring systems say everything is ok, testing says it's working, so I'm off home. No pictures yet, so messy it's embarrassing, and it isn't even working properly. Hopefully when I'm finished it will be worth a picture or two :)

Regards,
Adam

Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
