From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results
Date: Mon, 15 Apr 2013 22:23:23 +1000
Message-ID: <516BF13B.4010704@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <20776.59138.27235.908118@quad.stoffel.home> <5130D2EB.1070507@websitemanagers.com.au> <20130310153518.GQ5411@kevin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130310153518.GQ5411@kevin>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's been quite a while, and I just wanted to post an update on the
current status of my problems.

As a quick refresh, the users were complaining of freezing, especially
when using outlook (pst file stored on file server), and sometimes
corrupted pst files or excel files with windows logging delayed write
failures.

Most users using MS Win 2003 Terminal Servers

File Server was MS Win 2000 Server

All servers are Virtual Machines running one VM per physical machine
under Xen (Debian Linux Testing)

All disk images are stored on the storage server (Debian Linux Stable,
upgraded to backports kernel).
Storage server config is:
VM sees normal HDD
Linux physical machine exports disk device
Linux physical machine imports iSCSI from Storage Server
Storage server exports iSCSI device
One Logical Volume for each VM
The Physical Volume is a DRBD
The DRBD is a RAID5 using MD
The MD is a 5 x 480GB Intel SSD
The SSD's are connected with a LSI SATA 3 controller

The storage server has a single bond0 with 8 x Gbps ethernet connections
for the iSCSI network

Each Physical machine has 2 x Gbps ethernet for iSCSI plus 1 Gbps for
the "user" network

Testing has shown that each VM can read/write at between 200 and 230MB/s
concurrently to the storage server (up to 4 at a time obviously).

So, finally, I've found that the issue is NOT RAID related, in fact, it
is not even disk/storage related! Certainly, there were one or more
problems causing slow performance of the storage backend, but I would
suggest that it was never the actual problem. (Even though fixing those
issues was definitely a plus in the long term).

After sitting on-site for a few days, I eventually noticed my terminal
server session (across the LAN) stopped responding, after ping testing,
I found the server went offline for around 10 seconds before coming back
and working normally (yes, a total accident I discovered this). I added
a small script with fping to test all physical machine IP's and all VM
IP's every second for 60 seconds. Then, it will log the date/time the
test started, and each IP plus all 60 results for any IP that lost one
or more packets. (Reminder, this is over the LAN only, no WAN connections).

I found a "pattern" that showed one (at a time) random IP (VM or
physical, linux or windows), would stop responding to pings for between
10 and 50 seconds, then come back and work normally. These failures
would happen between zero and three times a day, generally occurring on
busy servers, either in the morning (users logging in) or afternoon
(users logging out).
In addition, random IP's drop a single ping packet around 40 or more
times per day, during business hours only.
There is never an outage of between two and 10 pings. There are lots of
single pings lost, and plenty between 10 and 50, but never any between 1
and 10. Sometimes (rarely) two or three in one minute, but not consecutive.

I suspect that the single ping packets being lost are an indication of a
problem, but this should not impact the users (TCP should look after the
re-transmission, etc). Wether this is related to the longer 10-50 second
outage I'm not sure.

I would expect that this network failure would explain all of the user
reported symptoms:
1) Terminal server freezes up and need to reboot the thin client to
   fix it (ie, wait a minute and reconnect to the session).
2) Windows delayed write failures normally manage to succeed (probably
   thanks to TCP reliability features) but sometimes SMB/TCP times out
   and so windows notices the network failure, and the write is failed,
   possibly corrupting the file being written to.

I've copied the testing script to a second machine, and the outages
(lasting more than a second) that each machine detects match (+/- a second).

All network cables were replaced with brand new cat6 cables (1m or 2M)
about 6 weeks ago.

The switch was a Netgear managed gigabit switch, but I replaced that
with a slightly older Netgear unmanaged gigabit switch with no change in
the results.

Overall network utilisation is minimal, the busiest server has an
average utilisation of 5Mbps during the day. Peak after hours traffic
(rsync backups over the LAN) will show sustained network utilisation of
around 80Mbps.

At this stage, I've moved totally away from suspecting a disk
performance or similar issue, and I don't think this can get any more
offtopic, but wanted to post a followup to my issue here. I still intend
to write something up to summarise the entire process once I eventually
get it resolved.

In the meantime, if anyone has any hints or suggestions on why a LAN
might be dropping packets like this, I'd be really happy to hear it,
because I'm scraping the bottom. Currently I'm using tcpdump to capture
ALL network traffic to local disk on 4 machines, and hoping that network
drop will happen on one of these 4. Then I can use wireshark to see what
happened during that time. If you've seen anything similar, got a random
suggestion (no matter how dumb) I'd be happy to hear it please.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
