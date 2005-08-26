From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: number of global spares?
Date: Fri, 26 Aug 2005 12:00:48 -0700
Message-ID: <1125082848.25483.23.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


I've been working on a RAID setup with dual RAID controllers and
three expansion boxes - 48 disks in all, including data, parity and
global spares.

We originally purchased the equipment expecting to get 16 terabytes of
usable space.

Now that it's "all set up", we're really seeing more like 14 or 15
terabytes, depending on how you do the calculation.

Please be sure to use a fixed-pitch font when viewing the tables found
below.  BTW, if people weren't so terrified of HTML, I could just make a
nice HTML table for easy reading without silly font requirements...

Anyway, what we have right now is:

global spares: 0,16,32,48

Raidset	Disks used	                  Data:parity ratio
0	      1,2,3,4,5,6,7,8,9,10          9:1
1	      11,17,18,19,20,21,22,23,24,25	9:1
2	      26,27,33,34,35,36,37,38,39,40	9:1
3	      41,42,43,49,50,51,52,53,54,55	9:1
4	      56,57,58,59                   3:1


And the vendor is suggesting that we move to something like:

global spares: 0

Raidset	Disks used	                  Data:parity ratio
0	      1,2,3,4,5,6,7,8,9,10          9:1
1	      11,17,18,19,20,21,22,23,24,25	9:1
2	      26,27,33,34,35,36,37,38,39,40	9:1
3	      41,42,43,49,50,51,52,53,54,55	9:1
4	      56,57,58,59,16,32,48          3:1

...or...:

global spares: 0,16

Raidset	Disks used	                  Data:parity ratio
0	      1,2,3,4,5,6,7,8,9,10          9:1
1	      11,17,18,19,20,21,22,23,24,25	9:1
2	      26,27,33,34,35,36,37,38,39,40	9:1
3	      41,42,43,49,50,51,52,53,54,55	9:1
4	      56,57,58,59,32,48             3:1


Does anyone have any comments on:

1) The sanity of these 10 disk RAID 5's?

2) The degree of loss of reliability incurred by moving 3 disks from
global spare to data?

3) The degree of loss of reliability incurred by moving 2 disks from
global spare to data?


To answer these questions, you probably need to know how the storage is to
be used.  This single, large filesystem will be used by a variety of
researchers and students from around The University of California, Irvine,
but was purchased primarily by the Earth System Science part of the
Physical Sciences department, which in turn will primarily be storing many
approximately 100 megabyte files which comprise time series related to
climatology simulations.

They don't feel that the storage has to be blazing fast, and 100% uptime
isn't paramount, however they very much do not want to lose their data.

The filesystem will not be backed up - we simply don't have anything large
enough to back it up -to-, so if the some part of the storage solution
goes kerflooey, we're totally...  er...  out of luck, and they'll probably
be looking at me (the primary sysadmin on the storage configuration),
wondering why their data is gone.

Thanks!

