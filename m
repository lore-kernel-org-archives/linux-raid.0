From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: AW: two-disk-failure question
Date: Sat, 25 Oct 2003 21:10:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310252110.57215.maarten@vbvb.nl>
References: <4D618F6493CE064A844A5D496733D66704E241@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D618F6493CE064A844A5D496733D66704E241@freedom.icomedias.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 18 October 2003 09:46, Martin Bene wrote:

> While the procedure you're refering to will still work, it's been made
> pretty much obsolete by the new mdadm tool.

Thanks.  I installed that.  I examined the disks and they seem to be in the 
same order as raidtab says.  From /var/log/messages I gather that the first 
disk that failed was /dev/hdf1. This is consistent with mdadm --examine, I 
think, since the superblock on disk hdf says all six are active, the 
superblock on hde says hdf is faulty, and the four other disks say both hde 
and hdf are faulty.

      Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync   /dev/hde1
   0     0      33        1        0      active sync   /dev/hde1
   1     1      33       65        1      faulty   /dev/hdf1
   2     2      34        1        2      active sync   /dev/hdg1
   3     3      34       65        3      active sync   /dev/hdh1
   4     4      56        1        4      active sync   /dev/hdi1
   5     5      57        1        5      active sync   /dev/hdk1

So after some reading and with hands shaking I did assemble it back by using 
mdadm leaving /dev/hdf1 out.

> Be careful when checking the results of the operation though: even mounting
> a filesystem readonly can result in write access to the device when using a
> journaling filesystem (ext3). Prior to mounting, it'll try to play back the
> jounal..

Thanks much for the warning !  This is indeed reiserfs, so I tried to find the 
least harmful way to check the array before mounting, which (I do hope) seems 
to be reiserfsck --check.  It is (still) running as I write this but I have 
good hopes since a botched array would probably not even resemble a reiserfs, 
much less report no fatal errors early in the check process.

> OK, that wasn't really helpful. What you really want to do is grab a copy
> of mdadm. It's got support for resolving just the problem you're
> experiencing: it can override the event counter when assembling an array
> but still use the rest of the raid superblock. In adition it can parse the
> information in the superblock and show you exactly what's in each of your
> superblocks.

Yes.  Thanks.  What does that "event counter" number mean ? (Events : 0.10)

> Bye, Martin

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
