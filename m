From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 11:22:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409141522.i8EFMW332429@watkins-home.com>
References: <20040914144624.GB1703@koocotte.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040914144624.GB1703@koocotte.org>
To: 'Sebastien Koechlin' <seb.kernel@koocotte.org>, 'Lukas Kubin' <kubin@opf.slu.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know this one!  Got to go from memory since I can't find Neil's answer.

md will do 4K disk I/O.  I am not sure about the size, but much smaller than
normal stripe size.
If you were to change 1 sector, md would read the 4K that contains the
sector, and read the 4K of parity.  Factor out the old data, factor in the
new data.  Then write the new 4K data and 4K parity.

- Get old data: 1 read (4K)
- Get current/old parity: 1 read (4K)
- factor out old data (XOR)
- compute new parity (XOR)
- Write data: 1 write (4k)
- Write parity: 1 write (4k)

There is some read-ahead, but I don't know what layer does that.
My array is over 3 times as fast as a single disk.  Using dd I get 19M/sec
on any 1 disk, but 61M/sec on the array.  My write speed is 30M/sec creating
a file on a filesystem.
Multi-threaded random read speed is much faster than 1 disk.  Maybe 14 times
faster, but not sure.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Sebastien Koechlin
Sent: Tuesday, September 14, 2004 10:46 AM
To: Lukas Kubin
Cc: Guy; linux-raid@vger.kernel.org
Subject: Re: Array of disks attached to multiple controllers

On Tue, Sep 14, 2004 at 04:07:43PM +0200, Lukas Kubin wrote:
>      Chunk Size : 128K
(...)
>     Number   Major   Minor   RaidDevice State
>        0       8       16        0      active sync   /dev/sdb
>        1       8       32        1      active sync   /dev/sdc
>        2       8       48        2      active sync   /dev/sdd
>        3       8       64        3      active sync   /dev/sde
>        4       8       80        4      active sync   /dev/sdf
>        5       8       96        5      active sync   /dev/sdg
>        6       8      112        6      active sync   /dev/sdh
>        7       8      128        7      active sync   /dev/sdi
>        8       8      144        8      active sync   /dev/sdj
>        9       8      160        9      active sync   /dev/sdk
>       10       8      176       10      active sync   /dev/sdl
>       11       8      192       11      active sync   /dev/sdm
>       12       8      208       12      active sync   /dev/sdn
>       13       8      224       13      active sync   /dev/sdo
>       14       8      240       14      active sync   /dev/sdp
>       15      65        0       15      active sync   /dev/sdq
>       16      65       16       16      spare   /dev/sdr

I have a question about performance: What is the cost of writing a
'data-unit' in such an array?

- Write data: 1 write
- Calculate new checksum: 14 reads
- Write checksum: 1 write

Right or wrong?

What is the granularity of thoses ckecksum updates? 512 bytes (sector size)?
4k (page size on i386)? chunk-size?

Does Linux do read-ahead on thoses 14 disks reads?

Thanks

-- 
Seb, autocuiseur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

