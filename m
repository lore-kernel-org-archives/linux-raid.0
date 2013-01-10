From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Thu, 10 Jan 2013 21:13:38 +0800
Message-ID: <50EEBE82.10501@fnarfbargle.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201212222044.27731.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201212222044.27731.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/12/12 11:44, Thomas Fjellstrom wrote:
>
> moose@mrbig:/mnt/mrbig/data/test$ iozone -a -s 32G -r 8M
>                                                              random  random
> bkwd   record   stride
>                KB  reclen   write rewrite    read    reread    read   write
> read  rewrite     read   fwrite frewrite   fread  freread
>          33554432    8192  212507  210382   630327   630852  372807  161710
> 388319  4922757   617347   210642   217122  717279   716150
>
> Is this normal for a 7 disk (2TB seagate barracudas) raid array on a pcie x8
> sas controller?
>

For comparo using the same command line. This is a running system and 
has a slight but measurable load on the array, but not enough that it 
should really impact the numbers.

This is 10 x WD 2TB Green drives (sloooow) in RAID-6 on a pair of those 
cards. Formatted ext4.

mpt2sas0: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x02), 
BiosVersion(00.00.00.00)

md0 : active raid6 sdl[0] sdr[5] sdo[6] sdp[7] sdn[8] sdk[9] sdm[10] 
sdq[11] sds[4] sdf[12]
       15628106752 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[10/10] [UUUUUUUUUU]
       bitmap: 2/15 pages [8KB], 65536KB chunk

                                                             random 
random    bkwd   record   stride
               KB  reclen   write rewrite    read    reread    read 
write    read  rewrite     read   fwrite frewrite   fread  freread
         33554432    8192  349745  448840   481170   488821  284313 
312892  355422  2288708   440818   397878   469964  478596   496619

Not sure this actually means anything though.

Regards,
Brad
