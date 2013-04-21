From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Sat, 20 Apr 2013 19:10:19 -0500
Message-ID: <51732E6B.3060000@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171CBF9.9020701@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Forgot to CC the list.  Sorry for the dup Andrei.

On 4/19/2013 5:58 PM, Andrei Banu wrote:

> I come to you with a difficult problem. We have a server otherwise
> snappy fitted with mdraid-1 made of Samsung 840 PRO SSDs. If we copy a
> larger file to the server (from the same server, from net doesn't
> matter) the server load will increase from roughly 0.7 to over 100 (for
> several GB files). Apparently the reason is that the raid can't write well.
...
> 547682517 bytes (548 MB) copied, 7.99664 s, 68.5 MB/s
> 547682517 bytes (548 MB) copied, 52.1958 s, 10.5 MB/s
> 547682517 bytes (548 MB) copied, 75.3476 s, 7.3 MB/s
> 1073741824 bytes (1.1 GB) copied, 61.8796 s, 17.4 MB/s
> Timing buffered disk reads:  654 MB in  3.01 seconds = 217.55 MB/sec
> Timing buffered disk reads:  272 MB in  3.01 seconds =  90.44 MB/sec
> Timing O_DIRECT disk reads:  788 MB in  3.00 seconds = 262.23 MB/sec
> Timing O_DIRECT disk reads:  554 MB in  3.00 seconds = 184.53 MB/sec
...

Obviously this is frustrating, but the fix should be pretty easy.

> O/S: CentOS 6.4 / 64 bit (2.6.32-358.2.1.el6.x86_64)

I'd guess your problem is the following regression.  I don't believe
this regression is fixed in Red Hat 2.6.32-* kernels:

http://www.archivum.info/linux-ide@vger.kernel.org/2010-02/00243/bad-performance-with-SSD-since-kernel-version-2.6.32.html

After I discovered this regression and recommended Adam Goryachev
upgrade from Debian 2.6.32 to 3.2.x, his SSD RAID5 throughput increased
by a factor of 5x, though much of this was due testing methods.  His raw
SSD throughput more than doubled per drive.  The thread detailing this
is long but is a good read:

http://marc.info/?l=linux-raid&m=136098921212920&w=2

-- 
Stan

