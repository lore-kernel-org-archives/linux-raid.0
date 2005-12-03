From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: building a disk server
Date: Sat, 03 Dec 2005 09:17:06 -0500
Message-ID: <4391A8E2.2070807@tmr.com>
References: <7f55de720511281555s6b30355atf2b943b5148b8c37@mail.gmail.com> <1133226093.4149.18.camel@dhcpc226.office.pivotlink.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1133226093.4149.18.camel@dhcpc226.office.pivotlink.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Dameron <brad@seatab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Dameron wrote:

>Might look at a Areca SATA RAID controller. They support up to 24 ports
>and has hardware level RAID capacity expansion. Or if you want to go
>cheaper look at the 3ware controller and use it in JBOD. That way you
>can get the Smart monitoring and hotplug. 
>
>Here is the server I built with 3TB usable for pretty cheap.
>All this was from www.8anet.com
>
>Supermicro SC933T-R760 3u or SC932T-R760 rackmount Chassis with 15 SATA
>Hot-Swap drive trays and triple redundant power supplies.
>Any motherboard and CPU will do. I would recommend a AMD64 CPU with a
>motherboard that has a PCI-X slot on it if possible. I used a Tyan S2468
>with dual Athlon 2800's and 2GB. 
>A 3ware 9500S-12. Not the 9500S-12MI with this case. Or the new
>9550SX-12 which is much faster now.
>12 - 300GB Maxtor MaXLine III drives
>2 - Western Digital 36GB 10k drives
>
>
>I use the 2 36GB drives mirrored for the OS since I had the extra slots.
>Could of went with a Areca 16 port card instead. But I already had the
>3ware laying around. I went with the 300GB Maxtor drives because at the
>time they were the ones that had SATAII NCQ (Native Command Queuing) and
>16MB cache. This setup is very fast and I use it as a NFS server for
>backing up my main servers. I currently have about 20% left out of 3TB.
>Time to add another one. 
>  
>

The only part of the hardware I would change is the CPU setup, a single 
dual core setup seems more cost and heat effective now. The controller 
is fine, but that just gets better with time as new stuff comes out.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

