From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 11:10:07 -0600
Message-ID: <5115316F.1090502@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5114A53B.9060103@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The information you've provided below seems to indicate the root cause
of the problem.  The good news is that the fix(es) are simple, and
inexpensive.

I must say, now that I understand the problem, I'm wondering why you
used 4 bonded GbE ports on your iSCSI target server, yet employed a
single GbE port on the only machine that accesses it, according to the
information you've presented.  Based on that, this is the source of your
problem.  Keep reading.

On 2/8/2013 1:11 AM, Adam Goryachev wrote:

> OK, so potentially, I may need to get a new controller board.
> Is there a test I can run which will determine the capability of the
> chipset? I can shutdown all the VM's tonight, and run the required tests...

Forget all of this.  The problem isn't with the storage server, but your
network architecture.

> From the switch stats, ports 5 to 8 are the bonded ports on the storage
> server (iSCSI traffic):
> 
> Int  PacketsRX  ErrorsRX  BroadcastRX PacketsTX  ErrorsTX  BroadcastTX
> 5    734007958  0         110         120729310  0         0
> 6    733085348  0         114         54059704   0         0
> 7    734264296  0         113         45917956   0         0
> 8    732964685  0         102         95655835   0         0

I'm glad I asked you for this information.  This clearly shows that the
server is performing LACP round robin fanning nearly perfectly.  It also
shows that the bulk of the traffic coming from the W2K DC, which
apparently hosts the Windows shares for TS users, is being pumped to the
storage server over port 5, the first port in the switch's bonding
group.  The switch is doing adaptive load balancing with transmission
instead of round robin.  This is the default behavior of many switches
and is fine.

> So, traffic seems reasonably well balanced across all four links

The storage server's transmit traffic is well balanced out of the NICs,
but the receive traffic from the switch is imbalanced, almost 3:1
between ports 5 and 7.  This is due to the switch doing ALB, and helps
us diagnose the problem.

> The win2k DC is on physical machine 1 which is on port 9 of the switch,
> I've included the above stats here as well:
> 
> Int  PacketsRX  ErrorsRX  BroadcastRX PacketsTX  ErrorsTX  BroadcastTX
> 5    734007958  0         110         120729310  0         0
> 6    733085348  0         114         54059704   0         0
> 7    734264296  0         113         45917956   0         0
> 8    732964685  0         102         95655835   0         0

> 9    1808508983 0         72998       1942345594 0         0

And here the problem is brightly revealed.  This W2K DC box on port 9
hosting the shares for the terminal services users appears to be
funneling all of your file IO to/from the storage server via iSCSI, and
to/from the terminal servers via CIFS-- all over a single GbE interface.
 Normally this wouldn't be a big problem.  But you have users copying
50GB files over the network, to terminal server machines no less.

As seen from the switch metrics, when a user does a large file copy from
a share on one iSCSI target to a share on another iSCSI target, here is
what is happening:

1.  The W2K DC share server pulls the filesystem blocks over iSCSI
2.  The storage server pushes the packets out round robin at 4x the rate
    that the DC can accept them, saturating its receive port
3.  The switch issues back offs to the server NICs during the entire
    length of the copy operation due to the 4:1 imbalance.  The server
    is so over powered with SSD and 4x GbE links this doesn't bog it
    down, but it does give us valuable information as to the problem
4.  The DC upon receiving the filesystem blocks immediately transmits
    them back to the other iSCSI target on the storage server
5.  Now the DC's transmit interface is saturated
6.  So now both Tx/Rx ports on the DC NIC are saturated
7.  Now all CIFS traffic on all terminal servers is significantly
    delayed due to congestion at the DC, causing severe lag for others
    doing file operations to/from the DC shares.
8.  If the TS/roaming profiles are on a share on this DC server
    any operation touching a profile will be slow, especially
    logon/off, as your users surely have massive profiles, given
    they save multi GB files to their desktops

> 802.3x Pause Frames Transmitted		1230476

"Bingo" metric.

> 2) The value for Pause Frames Transmitted, I'm not sure what this is,
> but it doesn't sound like a good thing....
> http://en.wikipedia.org/wiki/Ethernet_flow_control
> Seems to indicate that the switch is telling the physical machine to
> slow down sending data, and if these happen at even time intervals, then
> that is an average of one per second for the past 16 days.....

The average is irrelevant.  The switch only sends pauses to the storage
server NICs when they're transmitting more frames/sec than the single
port to which the DC is attached can forward them.  More precisely,
pauses are issued every time the buffer on switch port 9 is full when
ports 5-8 attempt to forward a frame.  The buffer will be full because
the downstream GbE NIC can't swallow the frames fast enough.  You've got
1.2 million of these pause frames logged.  This is your beacon in the
dark, shining bright light on the problem.

> I can understand that the storage server can send faster that any
> individual receiver, so I can see why the switch might tell it to slow
> down, but I don't see why the switch would tell the physical machine to
> slow down.

It's not telling the "physical machine" to "slow down".  It's telling
the ethernet device to pause between transmissions to the target MAC
address which is connected to the switch port that is under load
distress.  Your storage server isn't slowing down your terminal servers
or the users apps running on them.  Your DC is.

> So, to summarise, I think I need to look into the network performance,

You just did, and helped put the final nail in the coffin.  You simply
didn't realize it.  And you may balk at the solution, as it is so
simple, and cheap.  The problem, and the solution are:

Problem:
W2K DC handles all the client CIFS file IO traffic with the terminal
servers, as well as all iSCSI IO to/from the storage server, over a
single GbE interface.  It has a 4:1 ethernet bandwidth deficit with the
storage server alone, causing massive network congestion at the DC
machine during large file transfers.  This in turn bogs down CIFS
traffic across all TS boxen, lagging the users.

Solution:
Simply replace the onboard single port GbE NIC in the W2K DC share
server with an Intel quad port GbE NIC, and configure LACP bonding with
the switch. Use ALB instead of RR.  Using ALB will prevent the DC share
server from overwhelming the terminal servers in the same manner the
storage server is currently doing the DC.  Leave the storage server as RR.

However, this doesn't solve the problem of one user on a terminal server
bogging down everyone else on the same TS box if s/he pulls a 50GB file
to his/her desktop.  But the degradation will now be limited to only
users on that one TS box.  If you want to mitigate this to a degree, use
two bonded NIC ports in the TS boxen.  Here you can use RR transmit
without problems, as 2 ports can't saturate the 4 on the DC's new 4 port
NIC.  A 50GB transfer will take 4-5 minutes instead of the current 8-10.
 But my $deity, why are people moving 50GB files across a small biz
network for Pete's sake...  If this is an ongoing activity, you need to
look into Windows user level IO limiting so you can prevent one person
from hogging all the IO bandwidth.  I've never run into this before so
you'll have to research it.  May be a policy for it if you're lucky.
I've always handled this kinda thing with a cluestick.  On to the
solution, or at least most of it.

http://www.intel.com/content/dam/doc/product-brief/ethernet-i340-server-adapter-brief.pdf

You want the I340-T4, 4 port copper, obviously.  Runs about $250 USD,
about $50 less than the I350-T4.  It's the best 4 port copper GbE NIC
for the money with all the features you need.  You're already using 2x
I350-T2s in the server so this card will be familiar WRT driver
configuration, etc.  It's $50 cheaper than the I350-T4 but with all the
needed features.

Crap, I just remembered you're using consumer Asus boards for the other
machines.  I just checked the manual for the Asus M5A88-M and it's not
clear if anything but a graphics card can be used in the x16 slot...

So, I'd acquire one 4 port PCIe x4 Intel card, and two of these Intel 2
port x1 cards (Intel doesn't offer a 2 port x1 card):
http://www.intel.com/content/dam/www/public/us/en/documents/product-briefs/pro-1000-pt-server-adapter-brief.pdf

If the 4 port x4 card won't work, use the two single port x1 cards with
LACP ALB.  In which case you'll also want to switch the NICs on the
iSCSI server to ALB, or you'll still have switch congestion.  The 4 port
400MB/s solution would be optimal, but 200MB/s is still double what you
have now, and will help alleviate the problem, but won't eliminate it.
I hope the 4 port PCIe x4 card will work in that board.

If you must use the PCIe x1 single port cards, you could try adding a
PRO 1000 PCI NIC, and Frankenstein these 3 together with the onboard
Realtek 8111 to get 4 ports.  That's uncharted territory for me.  I
always use matching NICs, or at least all from the same hardware family
using the same driver.

I hope I've provided helpful information.

Keep us posted.

-- 
Stan

