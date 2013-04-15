From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID performance - new kernel results
Date: Mon, 15 Apr 2013 11:31:54 -0400
Message-ID: <20844.7530.817412.979677@quad.stoffel.home>
References: <51134E43.7090508@websitemanagers.com.au>
	<CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
	<51137FB8.6060003@websitemanagers.com.au>
	<CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
	<5113A2D6.20104@websitemanagers.com.au>
	<CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
	<51150475.2020803@websitemanagers.com.au>
	<5120A84E.4020702@websitemanagers.com.au>
	<20776.59138.27235.908118@quad.stoffel.home>
	<5130D2EB.1070507@websitemanagers.com.au>
	<20130310153518.GQ5411@kevin>
	<516BF13B.4010704@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516BF13B.4010704@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Adam,

Thanks for all your posting and continued updates on your travails
about getting the performance on your Xen systems and storage.  A
complete eye-opener in alot of ways.  

Now, from looking over your report, it strongly smells of a problem in
the network switch.  I think you have just one in the core of your
network, correct?  I'd probably try to bring up a test network (if you
have the spare systems in a lab) and try to replicate the packet
drops.

But in general, I'd probably:

  - remove the iSCSI bonding, goto a single 1Gb link.
  - get rid of jumbo frames, if you're using it.
  - can you reduce the size of your bond0 on the storage box?  

I wonder if the switch is having some sort of table over-flow, or is
just having some sort of brain fart and droppping a packet and then
needs time to rebuild it's tables internally to get things going
again?

I'd try to borrow a similar sized switch from another vendor and try
using that instead if you can.  Another thing is to try and use SNMP
to grab stats from the switch and look for patterns.  When you see
connectivity problems, do you see a corresponding drop on one of the
links on the bond0 connection?  Or on another bond?  

But, thinking about it more, you don't mention if you're dropping
packets on the iSCSI side of things, or just on the regular network.
That's a key observation, since it will either suggest, or refute my
idea of the problem being in the bond(s).  

Do you see any errors in the dmesg logs on the Xen/Linux/Windows
boxes?  And when you have an outage between two hosts, do pings to
*other* hosts still work just fine, or does all network traffic on
that host come to a stop?

It really smells of a switch problem.  Have you checked that the
switch firmware is upto date?  It might just be that Netgear makes a
crappy switch (cue people to chime on on this! :-) which can't handle
the load you're tossing at it.  Which is why I suggest you try another
vendor's switch.

Cisco is probably reliable but expensive.  Dell has some ok switches
in my experience, but nothing recent.  I've heard good things about
other brands such as Juniper, Force10 (now Dell) and others.  

Please keep posting, it's great information for the rest of us to keep
in the back of our heads.

John
