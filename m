From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: AW: RAID1 and data safety?
Date: Tue, 22 Mar 2005 16:08:34 +0100
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A80611526B@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Neil Brown wrote:
>>> Is there any way to tell MD to [...] and
>>> read-from-all-disks on a RAID1 array?
>
>Not sure why a checksum of X data blocks should be cheaper
>performance-wise than a comparison between X data blocks, but I can
>see the point in that you only have to load the data once and check
>the checksum.  Not quite the same security, but almost.

Still, if there is different data on the two disks due to a previous 
power failure, the comparsion could really be the better choise, isn't it?


