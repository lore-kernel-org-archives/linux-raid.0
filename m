From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results
Date: Mon, 15 Apr 2013 15:42:44 -0500
Message-ID: <516C6644.4010807@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <20776.59138.27235.908118@quad.stoffel.home> <5130D2EB.1070507@websitemanagers.com.au> <20130310153518.GQ5411@kevin> <516BF13B.4010704@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516BF13B.4010704@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/15/2013 7:23 AM, Adam Goryachev wrote:
...
> I suspect that the single ping packets being lost are an indication of a
> problem, but this should not impact the users (TCP should look after the
> re-transmission, etc). Wether this is related to the longer 10-50 second
> outage I'm not sure.
...
> All network cables were replaced with brand new cat6 cables (1m or 2M)
> about 6 weeks ago.

Server rack cables, but not *all* network cables.

> In the meantime, if anyone has any hints or suggestions on why a LAN
> might be dropping packets like this, I'd be really happy to hear it...

Sounds like a classic ground short or EMI issue.

Inexpensive switches tend to lack per port electrical isolation
circuitry.  Thus if there is a short across any of the 4 cable
conductors the switch may lock up while the condition exists and return
to normal operation when the condition is removed, possibly without
manual intervention required, no reboot or power cycle.  The normal
cause of this is a defective Ethernet transceiver in one of the devices
connected to the switch, or a break in a cable.  Depending on the
transceiver failure mode this can cause intermittent or permanent switch
lockup while the device is connected.  In this case it would seem to be
intermittent, if this is the cause of your problems.  This phenomenon is
limited to copper links.  Fiber doesn't conduct electricity.

Category 5/6 cable is pretty good at rejecting EMI/RFI.  But if the
cable is run in close proximity to anything generating a significant
stray magnetic field of the necessary amplitude, this may cause
electromagnetic induction in the cables, generating a current.  This
current can cause problems in the switch similar to that described above
if the switch isn't designed to deal with such conditions.

-- 
Stan

