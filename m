From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sun, 17 Feb 2013 04:19:44 +1100
Message-ID: <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.and
 roid.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511EDBCB.2000906@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:

>On 2/15/2013 8:32 AM, Adam Goryachev wrote:
>> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> 
>>> On 2/14/2013 6:22 AM, Stan Hoeppner wrote:
>>>
>>>> Then create 8 table entries with names, such as port_0 thru port_7:
>>>>
>>>> ~$ echo 100 port_0 >> /etc/iproute2/rt_tables
>>>> ......
>>>> ~$ echo 101 port_7 >> /etc/iproute2/rt_tables
>>>
>>> Correcting a typo here, this 2nd line above should read:
>>>
>>> ~$ echo 107 port_7 >> /etc/iproute2/rt_tables

>Even if you're conversing with Linus himself, it's always good to
>independently verify everything coming from a list, precisely due to
>things as mundane as typos, let alone things that are factually
>incorrect for one reason or another.  I've been guilty of both over the
>years, and I'd guess I have a lot of company. ;)  Most people don't
>intend to make such mistakes, but we all do, on occasion.

Sure, most people intend the best, but at the end of the day, I'm the one that will get yelled at if I get it wrong :)

>>> ** IMPORTANT **
>>> All of the work you've done with iscsiadm to this point has been
>>> with clients having a single iSCSI ethernet port and single server
>>> target port, and everything "just worked" without specifying local
>>> and target addresses (BTW, don't use the server hostname for any
>>> of these operations, obviously, only the IP addresses as they won't
>>> map). Since you will now have two local iSCSI addresses and
>>> potentially 8 target addresses, discovery and possibly operations 
>>> should probably be done on a 1:1 port basis to make sure both
>>> client ports are working and both are
>>> logging into the correct remote ports and mapping the correct LUNs.
>>> Executing the same shell command 128 times across 8 hosts, changing
>>> source and port IP addresses each time, seems susceptible to input
>>> errors.  Two per host less so.
>> Hmmm, 8 SAN IP's x 2 interfaces x 8 machines is a total of 128, or
>only 16 times on each machine. Personally, it sounds like the perfect
>case of scripting :)
>Look around.  Someone may have already written one.

OK, I don't think any of this is going to work properly... I have 11 targets at the moment, so with two interfaces on the xen box, and 2 ip's on the san, it is going to have 4 paths per target. So I need 44 paths, but after 32 it times out all the rest of them when doing a session login. I don't see how to reduce this any further without going back to the old 1Gbps maximum performance level (and still use MPIO). I'd have to limit which targets can be seen so only a max of 8 can be seen by any host. This will only get worse if I manage to get it all working and then add more VM's to the system, I could easily end up with 20 targets.

>> However, another downside is that if I add another 8 IP's on the
>secondary san, I have 16 SAN IP's x 2 interfaces x 8 machines, or 256
>entries. However, I think linux MPIO has a max of 8 paths anyway, so I
>was going to have to cull this down I suspect.

Well, I didn't even get to this... actually, exposing all 8 IP's on san1 produced 16 paths per Target, and I did see problems trying to get that working, which is why I dropped down to the 4 paths above.

>>> On paper, if multipath will fan all 8 remote ports from each client
>>> port, theoretically you could get better utilization in some client
>>> access pattern scenarios.  But in real world use, you won't see a
>>> difference.  Given the complexity of trying to use all 8 server
>>> ports per client port, if this was my network, I'd do it like this,
>>> conceptually:  http://www.hardwarefreak.com/lun-mapping.png
>>> Going the "all 8" route you'd add another 112 lines to that diagram
>>> atop the current 16.  That seems a little "busy" and unnecessary, more
>>> difficult to troubleshoot.
>> 
>> The downside to your suggestion is that if machine 1 and 5 are both
>busy at the same time, they only get 1Gbps each. Keep the vertical
>paths as is, but change the second path to an offset of only 1 (or 2 or
>3 would work, just not 4), then there are no pair of hosts sharing both
>ports, so two machines busy can still get 1.5Gbps.... 
>
>Just make sure you only "flip" four on one side of the diagram, so to
>speak.  Each Xen client should have a path to LUNs on each quad NIC for
>redundancy in case of server NIC failure.  Also note that multipath
>uses
>the round-robin path selector by default.  So if you do what you
>mention
>here you'll gain little or nothing from the potential positive ~50%
>bandwidth asymmetry in this 2 competing server situation.  To gain
>something you'd need to use the service-time path selector.  See
>multipath.conf for details.  Either way you may want to drop the value
>of rr_min_io down from the common default of 1000 so path selection is
>more frequent.  If you end up using the default round robin path
>selector, you'll want a low value for more balanced link utilization.
>
>>> Yes, I originally suggested fanning across all 8 ports, but after
>>> weighing the marginal potential benefit against the many negatives,
>>> it's clear to me that it's not the way to go.
>>>
>>> So during your next trip to the client, once you have all of your
>>> new cables and ties, it should be relatively quick to set this up. 
>>> Going the "all 8" route maybe not so quick.
>> I'm still considering the option of configuring the SAN server with
>two groups of 4 ports in a balance-alb bond, then the clients only need
>MPIO from two ports to two SAN IP's, or 4 paths each, plus the bond
>will manage the traffic balancing at the SAN server side across any two
>ports..... I can even lose the source based routing if I use different
>subnets and different VLAN's, and ignore the arp issues all around. I
>think that and your solution above are mostly equal, but I'll try the
>suggestion above first, if I get stuck, this would be my fallback
>plan.... 

So it seems even this won't work, because I will still have 4 paths per target... Which brings me back, to square one....

I need both xen ports in a single bond, each group of 4 ports on san1 in a bond, this provides 2 paths per target (or san could be 8 ports in one bond, and xen could use two interfaces individually), and then I can get up to 16 targets which at least lets me get things working now, and potentially scales a little bit further.

Maybe it is unusual for people to use so many targets, or something... I can't seem to find anything on google about this limit, which seems to be pretty low :(

>I suggested the source based routing setup because it allows for a
>single SAN subnet, which IMHO is cleaner, easier to manage,
>troubleshoot, etc, than 8 different subnets, but while yielding full
>link performance using multipath, same as the 8 subnets setup would.
>And assuming you're already using a single subnet, it should be as easy
>or easier to configure, as you simply have to create the routing table
>on the server(s) and each Xen client, and enable arp_filter.
>
>The solution you mention above seems conceptually easier and a bit
>cleaner that the 8 subnet setup, but it sacrifices some performance as
>balance-alb will not scale as well as multipath iSCSI using individual
>interfaces.  But given your peak SAN IO load isn't much more than
>100MB/s, it probably makes no difference which configuration you decide
>to go with.

I don't understand this.... MPIO to all 8 ports would have scaled the best, I think, since it would balance all traffic for all xen boxes equally over all interfaces at both the san and xen side.

However, using the 4 path per target method will limit performance depending on who those paths are shared with. Using balance-alb will allow linux to automatically assign 2 different interfaces for each client, and in theory, support full 8Gbps for ANY 4 clients by dynamically allocating the ports instead of some arbitrary static configuration.

What am I missing or not seeing? I'm sure I'm blinded by having tried so many different things now...

>There is a silver lining in the single subnet model, now that I think
>more about this.  It allows you to try the 8 port multipath fanning
>option, and if that doesn't work, or work well enough, you can simply
>fall back to the industry standard 2:2 configuration I mentioned most
>recently.  Since you'll be testing on just one Xen host, simply remove
>the appropriate 7 of 8 LUN logins on each of the two Xen client iSCSI
>interfaces (and restart multipathd), leaving just two, one to a port on
>each server NIC.  Test this configuration, which should work without
>issue as most are setup this way.  Then simply enable arp_filter on the
>other Xen boxen and populate their rt_tables.  The remaining steps of
>iscsiadmin and multipath setup are common to any of the setups.  Using
>this single subnet method requires no special switch configuration, no
>bonding, no VLANs, zip.  It's pretty much just like have 24 hosts on
>the same subnet, sans individual hostnames.

I just don't see why this didn't work for me.... I didn't even find an option to adjust this maximum limit. I only assume it is a limit at this stage...

>> I really need to get this done by Monday after today (one terminal
>server was offline for 30 minutes, you would think that was the end of
>the world....I thought 30 minutes was pretty good, since it took 20
>minutes for them to tell me........).
>The auto failover and load balancing of Citrix is pretty nice in such
>circumstances.

Apparently Citrix is too expensive for them.... One day I may implement some linux load balancing frontend, but lots of other things before I get to messing with something like that.... Like making sure everything works properly regardless of which TS the user logs into....

>> So, I'll let you know how it goes, and hopefully show off some flashy
>pictures to boot, and then next week will be the real test from the
>users...
>
>If your supplier has some purple and/or hot pink patch cables, go for
>it.  Dare to be different, and show you're cool. ;)  Truthfully, they
>just stand out better with digital cams.

Nope, I just got blue and yellow.... I think they had green, red, black, white, grey, etc... but no really exciting colours.

>> PS, the once a week backup process person advised that the backup on
>>thursday night was 10% faster than normal... So that was a promising
>>sign.
>Is this a LAN based backup through the DC file server, or SAN based
>backup?  Either way, there are probably some cheap ways to double its
>throughput now with all the extra SAN b/w soon to be available. :)

Effectively a three step process:
1 Stop the database, use the DB admin tool to "copy" the database to a new database (lots of insert transactions)
2 Copy the files the new database was saved in to another location on the same disk
3 zip those files.

So all three steps are doing lots of iSCSI read and write at the same time....

Regards,
Adam


Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
