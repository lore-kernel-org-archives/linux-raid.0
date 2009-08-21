From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Help
Date: Fri, 21 Aug 2009 20:38:00 +0100
Message-ID: <4A8EF798.9010600@anonymous.org.uk>
References: <200908210627.06241.Info@quantum-sci.net> <87ljldce33.fsf@frosties.localdomain> <200908211102.58744.Info@quantum-sci.net> <200908211220.28701.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908211220.28701.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/08/2009 20:20, Info@quantum-sci.net wrote:
> My God, the command is not working.  I need to remove sdb1 from md0 so I can change it from a RAID10 to RAID1, and it simply ignores my command:
> # mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
> md2 : active raid10 sdb3[1]
>       1868560128 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>       bitmap: 94/446 pages [376KB], 2048KB chunk
> 
> md1 : active raid10 sdb2[1]
>       6297344 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>       bitmap: 0/25 pages [0KB], 128KB chunk
> 
> md0 : active raid10 sdb1[1]
>       78654080 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>       bitmap: 76/151 pages [304KB], 256KB chunk

Well, it won't let you remove the only thing keeping the array active. 
Stop the array first with `mdadm --stop /dev/md0`. After that I think 
you can just create your new RAID-1 array without doing anything else.

Cheers,

John.
