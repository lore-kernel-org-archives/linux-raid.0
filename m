From: Luca Berra <bluca@comedia.it>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Fri, 8 Jul 2011 07:40:45 +0200
Message-ID: <20110708054045.GA28420@maude.comedia.it>
References: <20110706161228.GA1491@apartia.fr> <4E1494BB.9060101@turmel.org> <20110707090540.GA7288@apartia.fr> <4E15A980.3060508@turmel.org> <20110707130917.GA18812@apartia.fr> <4E15B576.9040004@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E15B576.9040004@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 07, 2011 at 09:32:38AM -0400, Phil Turmel wrote:
>On 07/07/2011 09:09 AM, Louis-David Mitterrand wrote:
>> On Thu, Jul 07, 2011 at 08:41:36AM -0400, Phil Turmel wrote:
...
>>> echo 0 1683724288 linear /dev/md1 2048 | dmsetup create mdtest
>> 
....
>> 
>> root@grml /dev/mapper # xfs_check /dev/mapper/cmd1
>> xfs_check: /dev/mapper/cmd1 is not a valid XFS filesystem (unexpected SB magic number 0xd0f1b462)
>> xfs_check: size check failed
>
>This is important.  When I computed the sector count for the linear mapping, I just took 2048 off the end.  You may want to select a sector count that aligns the endpoint.
but the xfs sb should be at sector 0

>If the md array is assembled with devices out of order, the initialization vectors for all the sectors are likely to be wrong, with no way to examine the contents to try to work out the device order.  Of course, I don't know of any way mdadm can screw up the device order with v1+ metadata.
>
>>> I also wonder if the md device itself was partitioned, maybe with EFI
>>> GPT, and the grml liveCD doesn't support it?  (Long shot.)  Please
>>> show "zcat /proc/config.gz |grep PART"
if the md itself were partitioned i would expect to see a partition
table somewhere between the start and the liks header, but from the
posted od it is 1M of zeroes.

also from the lsdrv i see another array named zenon, while this is named
grml (i suppose the hostname of your server is the former), this makes
me wonder...
i do not have a debian, but from what i found of the man-page the script
should be harmless, but.
the luks header starts at 1M, which is a multiple of the 512K chunk
size, which could be a symptom of mis-ordered devices.
did you keep any log when you ran the mdadm-startall?
did md1 resync?

L.


-- 
Luca Berra -- bluca@comedia.it
