From: PFC <lists@peufeu.com>
Subject: Re: Concept problem with RAID1?
Date: Fri, 24 Mar 2006 17:07:04 +0100
Message-ID: <op.s6xdp2nmcigqcu@apollo13>
References: <212703968.20060324131659@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <212703968.20060324131659@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



	I think you would like something like this :

	A LVM (or dm- device mapper) layer which sits between the RAID layer and  
the physical disks. This layer computes checksums as data is written to  
the physical disks, and checks read data against these checksums.

	Problem is, where do you store the checksums ? You need a rather fast,  
non-volatile memory to do this. An interesting option would be an USB key.  
However, flash memory has a limited number of write cycles. Some scheme  
would be needed to not always overwrite the same spot on the flash memory.

	Interesting...
