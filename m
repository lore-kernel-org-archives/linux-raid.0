From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID performance - new kernel results
Date: Tue, 16 Apr 2013 17:03:15 -0400
Message-ID: <516DBC93.8030302@turmel.org>
References: <20372204.0.1366140527266.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20372204.0.1366140527266.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

On 04/16/2013 03:28 PM, Roy Sigurd Karlsbakk wrote:
>>> I suspect that the single ping packets being lost are an
>>> indication of a problem, but this should not impact the users
>>> (TCP should look after the re-transmission, etc). Wether this is
>>> related to the longer 10-50 second outage I'm not sure.
>> 
>> No, single lost pings are *not* a sign of a problem. It is
>> perfectly normal for a network to have random traffic spikes that
>> fill a switch's store-and-forward buffers. ICMP pings are
>> *datagrams*, like UDP, so they aren't retransmitted when dropped.
>> Losing them as infrequently as you say suggests your network isn't
>> heavily loaded.
> 
> Switches (unlike bridges) do not use store-and-forward. They use
> cut-through, meaning they use store-and-forward for the initial
> packet from A to B and then store the path and switch it later,
> sniffing the MAC addresses and just use pass-through.

Nothing you said changes my statement that switches often drop single
packets.  The occasional dropped ping is a red herring.  A cheap switch
that can't ever buffer will simply drop *more* random packets.

> As was said, the traffic on the network was minimal, so I really
> doubt this had an impact. Getting 30 seconds+ of drops must come from
> a bad network stack or a really bad switch, but then again, two
> switches were tested, so I doubt the switches alone could do that.

We seem to violently agree here.  Multiple consecutive drops is a real
problem.

> What may be doing it, is bad (or perhaps incompatible) bonding
> setup.

My point was to not prematurely conclude that the problem is in the network.

Phil
