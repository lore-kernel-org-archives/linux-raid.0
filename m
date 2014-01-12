From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: read errors not corrected when doing check on RAID6
Date: Sun, 12 Jan 2014 18:12:34 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401121807350.20074@uplift.swm.pp.se>
References: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Jan 2014, Mikael Abrahamsson wrote:

After the replace event is done, here is an excerpt (at 569 I initiated 
the inital "check". At 74791 I initiated the replace of sds.

# dmesg | egrep -i 'end_request|md0'
[  103.321478] md: md0 stopped.
[  103.697351] md/raid:md0: device sdn operational as raid disk 0
[  103.697408] md/raid:md0: device sde operational as raid disk 9
[  103.697464] md/raid:md0: device sdf operational as raid disk 8
[  103.697520] md/raid:md0: device sdc operational as raid disk 7
[  103.697575] md/raid:md0: device sdb operational as raid disk 6
[  103.697631] md/raid:md0: device sdv operational as raid disk 5
[  103.697687] md/raid:md0: device sds operational as raid disk 4
[  103.697742] md/raid:md0: device sdd operational as raid disk 3
[  103.699136] md/raid:md0: device sdj operational as raid disk 2
[  103.699191] md/raid:md0: device sdh operational as raid disk 1
[  103.699925] md/raid:md0: allocated 10674kB
[  103.700000] md/raid:md0: raid level 6 active with 10 out of 10 devices, algorithm 2
[  103.700233] created bitmap (15 pages) for device md0
[  103.700714] md0: bitmap initialized from disk: read 1 pages, set 0 of 29809 bits
[  103.785552] md0: detected capacity change from 0 to 16003178168320
[  103.791690]  md0: unknown partition table
[  569.034292] md: data-check of RAID array md0
[  714.808494] end_request: I/O error, dev sds, sector 8141872
[  868.466729] end_request: I/O error, dev sds, sector 16075040
[ 1095.400603] end_request: I/O error, dev sds, sector 28157152
[ 1119.427166] end_request: I/O error, dev sds, sector 29280528
[45411.209327] md: md0: data-check done.
[74791.252331] md: recovery of RAID array md0
[74872.828979] end_request: I/O error, dev sds, sector 8126192
[74877.936701] end_request: I/O error, dev sds, sector 8126192
[74877.936730] end_request: I/O error, dev sds, sector 8126192
[74884.296967] end_request: I/O error, dev sds, sector 8141872
[74889.572708] end_request: I/O error, dev sds, sector 8141872
[74889.572737] end_request: I/O error, dev sds, sector 8141872
[74891.334029] md/raid:md0: read error corrected (8 sectors at 8126192 on sds)
[74891.353112] md/raid:md0: read error corrected (8 sectors at 8141872 on sds)
[75038.596998] end_request: I/O error, dev sds, sector 29280528
[75043.278096] end_request: I/O error, dev sds, sector 29280528
[75043.278124] end_request: I/O error, dev sds, sector 29280528
[75043.464460] md/raid:md0: read error corrected (8 sectors at 29280528 on sds)
[75055.565033] end_request: I/O error, dev sds, sector 30348408
[75060.840703] end_request: I/O error, dev sds, sector 30348408
[75060.840731] end_request: I/O error, dev sds, sector 30348408
[75061.051075] md/raid:md0: read error corrected (8 sectors at 30348408 on sds)
[75067.796988] end_request: I/O error, dev sds, sector 30733328
[113272.067198] md: md0: recovery done.

# smartctl -a /dev/sds | grep -i pending
197 Current_Pending_Sector  0x0032   100   100   000    Old_age   Always       -       4

So sds has gone down from 9 to 4 pending sectors during the replace 
operation. This doesn't make sense to me at all. Above seems to indicate 
that md wants 3 read errors in order to correct?

# smartctl -a /dev/sds | less
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.11-0.bpo.2-amd64] (local 
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
LU WWN Device Id: 5 0024e9 004b27bb0
Firmware Version: 1AQ10001
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6

From dmesg as well:

[113272.067198] md: md0: recovery done.
[113272.528813] RAID conf printout:
[113272.528818]  --- level:6 rd:10 wd:10
[113272.528821]  disk 0, o:1, dev:sdn
[113272.528824]  disk 1, o:1, dev:sdh
[113272.528827]  disk 2, o:1, dev:sdj
[113272.528829]  disk 3, o:1, dev:sdd
[113272.528831]  disk 4, o:0, dev:sds
[113272.528834]  disk 5, o:1, dev:sdv
[113272.528836]  disk 6, o:1, dev:sdb
[113272.528839]  disk 7, o:1, dev:sdc
[113272.528841]  disk 8, o:1, dev:sdf
[113272.528844]  disk 9, o:1, dev:sde
[113272.661106] RAID conf printout:
[113272.661111]  --- level:6 rd:10 wd:10
[113272.661113]  disk 0, o:1, dev:sdn
[113272.661114]  disk 1, o:1, dev:sdh
[113272.661116]  disk 2, o:1, dev:sdj
[113272.661118]  disk 3, o:1, dev:sdd
[113272.661119]  disk 4, o:0, dev:sds
[113272.661121]  disk 5, o:1, dev:sdv
[113272.661123]  disk 6, o:1, dev:sdb
[113272.661124]  disk 7, o:1, dev:sdc
[113272.661126]  disk 8, o:1, dev:sdf
[113272.661127]  disk 9, o:1, dev:sde
[113272.668116] RAID conf printout:
[113272.668120]  --- level:6 rd:10 wd:10
[113272.668123]  disk 0, o:1, dev:sdn
[113272.668126]  disk 1, o:1, dev:sdh
[113272.668129]  disk 2, o:1, dev:sdj
[113272.668132]  disk 3, o:1, dev:sdd
[113272.668134]  disk 4, o:1, dev:sdk
[113272.668137]  disk 5, o:1, dev:sdv
[113272.668139]  disk 6, o:1, dev:sdb
[113272.668142]  disk 7, o:1, dev:sdc
[113272.668145]  disk 8, o:1, dev:sdf
[113272.668147]  disk 9, o:1, dev:sde

So the operation was successful it seems, it's just that I don't 
udnerstand why the initial "check" didn't find and fix all the pending 
sectors?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
