From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID performance - new kernel results
Date: Mon, 15 Apr 2013 16:16:24 -0400
Message-ID: <516C6018.5030800@turmel.org>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <20776.59138.27235.908118@quad.stoffel.home> <5130D2EB.1070507@websitemanagers.com.au> <20130310153518.GQ5411@kevin> <516BF13B.4010704@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516BF13B.4010704@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/15/2013 08:23 AM, Adam Goryachev wrote:
> It's been quite a while, and I just wanted to post an update on the
> current status of my problems.

Thanks for updating us.

> As a quick refresh, the users were complaining of freezing, especially
> when using outlook (pst file stored on file server), and sometimes
> corrupted pst files or excel files with windows logging delayed write
> failures.

[trim /]

> After sitting on-site for a few days, I eventually noticed my terminal
> server session (across the LAN) stopped responding, after ping testing,
> I found the server went offline for around 10 seconds before coming back
> and working normally (yes, a total accident I discovered this). I added
> a small script with fping to test all physical machine IP's and all VM
> IP's every second for 60 seconds. Then, it will log the date/time the
> test started, and each IP plus all 60 results for any IP that lost one
> or more packets. (Reminder, this is over the LAN only, no WAN connections).
> 
> I found a "pattern" that showed one (at a time) random IP (VM or
> physical, linux or windows), would stop responding to pings for between
> 10 and 50 seconds, then come back and work normally. These failures
> would happen between zero and three times a day, generally occurring on
> busy servers, either in the morning (users logging in) or afternoon
> (users logging out).
> In addition, random IP's drop a single ping packet around 40 or more
> times per day, during business hours only.
> There is never an outage of between two and 10 pings. There are lots of
> single pings lost, and plenty between 10 and 50, but never any between 1
> and 10. Sometimes (rarely) two or three in one minute, but not consecutive.
> 
> I suspect that the single ping packets being lost are an indication of a
> problem, but this should not impact the users (TCP should look after the
> re-transmission, etc). Wether this is related to the longer 10-50 second
> outage I'm not sure.

No, single lost pings are *not* a sign of a problem.  It is perfectly
normal for a network to have random traffic spikes that fill a switch's
store-and-forward buffers.  ICMP pings are *datagrams*, like UDP, so
they aren't retransmitted when dropped.  Losing them as infrequently as
you say suggests your network isn't heavily loaded.

(Smart switches will attempt to notify hosts of buffer-full conditions,
but that just means the datagram is dropped in the host's IP stack
instead of on the wire.)

Loosing multiple pings as you describe, with matching freezes on UIs,
does sound like a serious problem.

[trim /]

> At this stage, I've moved totally away from suspecting a disk
> performance or similar issue, and I don't think this can get any more
> offtopic, but wanted to post a followup to my issue here. I still intend
> to write something up to summarise the entire process once I eventually
> get it resolved.
> 
> In the meantime, if anyone has any hints or suggestions on why a LAN
> might be dropping packets like this, I'd be really happy to hear it,
> because I'm scraping the bottom. Currently I'm using tcpdump to capture
> ALL network traffic to local disk on 4 machines, and hoping that network
> drop will happen on one of these 4. Then I can use wireshark to see what
> happened during that time. If you've seen anything similar, got a random
> suggestion (no matter how dumb) I'd be happy to hear it please.

Don't forget to put performance/latency monitors in your hosts...  There
might be a hardware issue in a critical node that is triggering this.
This might be visible in your four wireshark machines where they
suddenly fail to record many packets.  In other words, where one machine
sees a gap in traffic, and other machines transmit many retries,
suggests that first machine has an internal problem.
> 
> Regards,
> Adam

HTH,

Phil
