From: Sebastien Koechlin <seb.kernel@koocotte.org>
Subject: Re: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 16:46:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040914144624.GB1703@koocotte.org>
References: <200409141357.i8EDvg332052@watkins-home.com> <4146FB2F.9080103@opf.slu.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4146FB2F.9080103@opf.slu.cz>
To: Lukas Kubin <kubin@opf.slu.cz>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
