From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sun, 10 Feb 2013 21:48:51 +0100
Message-ID: <511807B3.3070105@evilazrael.de>
References: <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk> <510C5E3F.8090807@evilazrael.de> <510C6AB6.8040900@turmel.org> <510D36D7.5050704@evilazrael.de> <510DBBB9.5030300@turmel.org> <510E88B3.8050505@evilazrael.de> <20130203215934.GB18805@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130203215934.GB18805@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello ML,

thanks Chris, Phil & Robin. You helped me alot.

After replacing the Marvell Controller with a LSI SAS2008-based
Controller (IBM M1015 flashed to 9211-IT) the RAID was rebuilt
successfully and is running clean and stable. So the cause of the
problems was one HDD with UREs and the unstable Marvell controller. My
next steps are going to RAID6 and a bigger chunk size and scrubbing the
RAID periodically.

I have a last question. I am wondering that reading a huge file in the
XFS on the Array is faster than reading the raw md0 device. Has anybody
an explanation for that?

9 Drives RAID5, chunk size 64kb, Filesystem XFS not optimized:
# echo 3 > /proc/sys/vm/drop_caches
# dd if=dummy.file of=/dev/null bs=1M count=100k
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 211.467 s, 508 MB/s

# echo 3 > /proc/sys/vm/drop_caches
# dd if=/dev/md0 of=/dev/null bs=1M count=100k
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 263.738 s, 407 MB/s

# echo 3 > /proc/sys/vm/drop_caches
# dd if=/dev/md0 of=/dev/null bs=64k count=1600k
1638400+0 records in
1638400+0 records out
107374182400 bytes (107 GB) copied, 253.76 s, 423 MB/s

# echo 3 > /proc/sys/vm/drop_caches
# dd if=/dev/md0 of=/dev/null bs=512k count=200k
204800+0 records in
204800+0 records out
107374182400 bytes (107 GB) copied, 260.837 s, 412 MB/s

# echo 3 > /proc/sys/vm/drop_caches
# dd if=/dev/md0 of=/dev/null bs=576k count=200k
204800+0 records in
204800+0 records out
120795955200 bytes (121 GB) copied, 296.567 s, 407 MB/s

Once again thanks for all help

Kind Regards

Christoph

Am 03.02.2013 22:59, schrieb Robin Hill:
> On Sun Feb 03, 2013 at 04:56:35 +0100, Christoph Nelles wrote:
> 
>> Hi folks,
>>
>> the dd_rescue to the new HDD took 14hours. It looks like ddrescue is not
>> reading and writing in parallel. In the end 8kb couldn't be read after
>> 10 retries.
>>
> Note that there's a difference between dd_rescue and ddrescue. GNU
> ddrescue seems to be the better option nowadays,
> 
>> I just force-assembled the RAID with the new drive, but it failed almost
>> immediately with an WRITE FPDMA QUEUED error on one of the other drives
>> (sdj, formerly sdi). I tried immediately again, an this time one disk
>> was rejected but the RAID started on 8 devices, but xfs_repair failed
>> when one of the disks failed with an READ FPDMA QUEUED error :( and md
>> expelled the disk from the RAID.
>>
>> It looks more like a controller problem as all the messages comming from
>> the drives on the PCIe Marvell have all the line
>> ataXX: illegal qc_active transition (00000002->00000003)
>> I found only one similar report about that problem:
>> http://marc.info/?l=linux-ide&m=131475722021117
>>
>> Any recommendations for a decent and affordable SATA Controller with at
>> least 4 ports and faster than PCIe x1? Looks like there are only
>> Marvells and more expensive Enterprise RAID controllers.
>>
> 
> I can recommend the Intel RS2WC080 (or any other LSI SAS2008 based
> controller). Quite frankly, any SAS controller is almost certainly
> going to be better than the SATA equivalent (and for not a huge amount
> more), while still supporting standard SATA drives.
> 
> Cheers,
>     Robin


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt

