From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Re: Antw: Problems creating MD-RAID1: "device .. not suitable
 for any style of raid array" / "Device or resource busy"
Date: Thu, 12 May 2011 12:38:40 +0200
Message-ID: <4DCBD4D0020000A100005D6C@gwsmtp1.uni-regensburg.de>
References: <4DCABB80020000A100005D46@gwsmtp1.uni-regensburg.de>
 <4DCAC0B3.8010509@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> Ulrich Windl schrieb am 12.05.2011 um 08:07 in Nachricht <4DCB793A.C19 : 161 :
60728>:

The problem seems to be a mis-calculated bitmap size or position, indeed:

May 12 08:06:00 hostname kernel: [55956.959794] md3: bitmap file is out of date
(0 < 70) -- forcing full recovery
May 12 08:06:00 hostname kernel: [55956.959798] md3: bitmap file is out of
date, doing full recovery
May 12 08:06:00 hostname kernel: [55957.054583] attempt to access beyond end of
device
May 12 08:06:00 hostname kernel: [55957.054585] dm-16: rw=192, want=62914561,
limit=62914560
May 12 08:06:00 hostname kernel: [55957.054587] attempt to access beyond end of
device
May 12 08:06:00 hostname kernel: [55957.054588] dm-9: rw=192, want=62914561,
limit=62914560
May 12 08:06:00 hostname kernel: [55957.054589] md3: bitmap initialisation
failed: -5
May 12 08:06:00 hostname kernel: [55957.055058] md: couldn't update array info.
-5

[...]
> P.S. Amazing things happen now and then:
> # cat /proc/mdstat
> Personalities : [linear] [raid1]
> md2 : active raid1 dm-17[1] dm-10[0]
>       209715136 blocks [2/2] [UU]
> 
> md1 : active raid1 dm-12[0] dm-14[1]
>       20971456 blocks [2/2] [UU]
> 
> md3 : active raid1 dm-16[0] dm-9[1]
>       31457216 blocks [2/2] [UU]
> 
> md0 : active raid1 dm-11[0] dm-8[1]
>       525336512 blocks [2/2] [UU]
> 
> unused devices: <none>
> # mdadm --grow --bitmap=internal /dev/md0
> # mdadm --grow --bitmap internal /dev/md1
> # mdadm --grow --bitmap internal /dev/md2
> # mdadm --grow --bitmap=internal /dev/md3
> mdadm: failed to set internal bitmap.
> # cat /proc/mdstat
> Personalities : [linear] [raid1]
> md2 : active raid1 dm-17[1] dm-10[0]
>       209715136 blocks [2/2] [UU]
>       bitmap: 0/200 pages [0KB], 512KB chunk
> 
> md1 : active raid1 dm-12[0] dm-14[1]
>       20971456 blocks [2/2] [UU]
>       bitmap: 0/160 pages [0KB], 64KB chunk
> 
> md3 : active raid1 dm-16[0] dm-9[1]
>       31457216 blocks [2/2] [UU]
> 
> md0 : active raid1 dm-11[0] dm-8[1]
>       525336512 blocks [2/2] [UU]
>       bitmap: 0/126 pages [0KB], 2048KB chunk
> 
> unused devices: <none>
> 
> 


 

