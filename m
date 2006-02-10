From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: NVRAM support
Date: Fri, 10 Feb 2006 13:42:05 +0100
Message-ID: <20060210124204.GC28676@harddisk-recovery.com>
References: <43EC5655.1060504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43EC5655.1060504@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 10, 2006 at 10:01:09AM +0100, Mirko Benz wrote:
> Does a high speed NVRAM device makes sense for Linux SW RAID? E.g. a PCI 
> card that exports battery backed memory.

Unless it's very large (i.e.: as large as one of your disks), it
doesn't make sense. It will probably break less often, but it doesn't
help you in case a disk really breaks. It also won't speed up an MD
device much.

> Could that significantly improve write speed for RAID 5/6 (e.g. via an 
> external journal, asynchronous operation and write caching)?

You could use it for an external journal, or you could use it as a swap
device.

> What changes would be required?

None, ext3 supports external journals. Look for the -O option in the
mke2fs manual page. Using the NVRAM device as swap is not different
from a using "normal" swap partition.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
