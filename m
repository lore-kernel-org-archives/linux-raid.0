From: Axel Christiansen <axel@zedx.org>
Subject: Re: raid5 resync 2.6.10 freez
Date: Wed, 05 Jan 2005 11:18:42 +0100
Message-ID: <41DBBF02.5010407@zedx.org>
References: <41D8377F.2040809@zedx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41D8377F.2040809@zedx.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Axel Christiansen wrote:
> Hello,
> 
> i recently upgraded to a 4-IDE-RAID5. Since than the array
> is not able to resync itself.
> 
> linux 2.6.10 with software-raid
> mdadm - v1.5.0 - 22 Jan 2004
> 4 X IDE DISK WDC WD1600JB-00FUA0 (160 GB)
> 2 X HPT374 (rev 07) IDE Conroller
> Epox 8K5-A3+
> Duron 1500 MHz CPU
> 
> After 5 to 10 minutes the os freez. The system console does
> not show anything.

With the ide/scsi driver from highpont v2.12 the array is doing
a full resync. Sadly the module does not compile with
Linux 2.6.10

Greets, Axel
