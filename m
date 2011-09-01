From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 17:48:34 +0100
Message-ID: <4E5FB762.4050003@yuiop.co.uk>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FAFE9.3040604@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FAFE9.3040604@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/09/2011 17:16, Pim Zandbergen wrote:
> # gdisk -l /dev/sdk
[...]
> Number Start (sector) End (sector) Size Code Name
> 1 2048 5860533134 2.7 TiB FD00 Linux RAID

Partition type FD is only for metadata 0.90 arrays to be auto-assembled 
by the kernel. This is now deprecated; you should be using partition 
type DA (Non-FS data) and an initrd to assemble your arrays.

> # mdadm --examine /dev/sdk1
> /dev/sdk1:
> Magic : a92b4efc
> Version : 0.90.03

Metadata version 0.90 does not support devices over 2TiB. I think it's a 
bug that you weren't warned at some point.

Cheers,

John.


-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
