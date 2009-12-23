From: Asdo <asdo@shiftmail.org>
Subject: Re: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 15:49:11 +0100
Message-ID: <4B322DE7.5010403@shiftmail.org>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
 <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
 <953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230548v1abacfcciadaab2888018b202@mail.gmail.com>
 <927342042.20091223150200@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230604m55eb6225sf68a819c6025e7b@mail.gmail.com>
 <1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1913939922.20091223153028@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rainer Fuegenstein wrote:
> MB> mdadm -Af /dev/md0
> MB> If that doesn't work for any reason, do this:
> MB> mdadm -Af /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sdc1
>
> MB> You can note the disk order from the output of mdadm -E
>   

The --assemble --force needs correct order of drives to be specified!?!?
I think it autodetects that
(would be EXTREMELY RISKY otherwise...)

Rainer, just after starting the array you can:
  mdadm --readonly /dev/md0
so to be sure that no writes ever happen and a resync does not happen.

I suggest to take data out before doing any modifications (such as a 
resync), if you can.

note: xfs needs -o ro,nobarrier,norecovery upon mount, in order to be 
mounted from a readonly array.

As MB suggests, it's better to keep the the most recently failed drive 
out of the array if possible, in order to have more coherent data. Also  
true when you are going to add the first spare (that will cause a resync 
and regeneration of one disk).
