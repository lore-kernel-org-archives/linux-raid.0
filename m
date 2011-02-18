From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Fri, 18 Feb 2011 17:16:38 -0600
Message-ID: <4D5EFDD6.1020504@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mattias Wadenstein put forth on 2/18/2011 7:49 AM:

> Here you would either maintain a large list of nfs mounts for the read
> load, or start looking at a distributed filesystem. Sticking them all
> into one big fileserver is easier on the administration part, but
> quickly gets really expensive when you look to put multiple 10GE
> interfaces on it.

This really depends on one's definition of "really expensive".  Taking
the total cost of such a system/infrastructure into account, these two
Intel dual port 10 GbE NICs seem rather cheap at $650-$750 USD:

http://www.newegg.com/Product/Product.aspx?Item=N82E16833106037
http://www.newegg.com/Product/Product.aspx?Item=N82E16833106075

20 Gb/s (40 both ways) raw/peak throughput at this price seems like a
bargain to me (plus the switch module cost obviously, if required,
usually not for RJ-45 or CX4, thus my motivation for mentioning these).

The storage infrastructure on the back end required to keep these pipes
full will be the "really expensive" piece.  With 40-50 NFS clients you
end up with a random read/write workload, as has been mentioned.  To
sustain 2 GB/s throughput (CRC+TCP+NFS+etc overhead limited) under such
random IO conditions is going to require something on the order of 24-30
15k SAS drives in a RAID 0 stripe, or 48-60 such drives in a RAID 10,
assuming something like 80-90% efficiency in your software or hardware
RAID engine.  To get this level of sustained random performance from the
Nexsan arrays you'd have to use 2 units as the controller hardware just
isn't fast enough.  This is also exactly why NetApp does good business
in the midrange segment--one unit does it all, including block and file.

RAID 5/6 need not apply due the abysmal RMW partial stripe write
penalty, unless of course you're doing almost no writes.  But in that
case, how did the data get there in the first place? :)

-- 
Stan
