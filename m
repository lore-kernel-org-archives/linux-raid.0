From: Phil Turmel <philip@turmel.org>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 21:39:30 -0500
Message-ID: <54DAC0E2.2070303@turmel.org>
References: <54DAB614.70302@athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DAB614.70302@athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: athompso@athompso.net, linux-raid@vger.kernel.org
Cc: "Board, MUUG" <board@muug.mb.ca>, elrepo@lists.elrepo.org
List-Id: linux-raid.ids

Hi Adam,

On 02/10/2015 08:53 PM, Adam Thompson wrote:
> So, I was doing some work on the new server tonight, stopping/starting
> NFS caused a kernel panic, and I thought rebooting would be a good
> idea... Apparently not!

> Sure enough, no array.
>> [root@muug ~]# cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
>> md0 : active raid1 sdm1[0] sdn1[1]
>>       1048512 blocks super 1.0 [2/2] [UU]
>>       bitmap: 0/1 pages [0KB], 65536KB chunk
>>
>> md127 : inactive sdk[10] sdj[9] sdi[8] sdl[12]
>>       15627550048 blocks super 1.2
>>
>> unused devices: <none>

Not really no array -- this remnant is inactive.  On older kernel /
mdadm combinations, you have to --stop the inactive array before you try
again.  Please add --verbose to your --assemble --force

If that doesn't work, use a bootable thumb drive with current kernel and
mdadm and --assemble --force again.

Phil
