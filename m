From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: IDE bus rescan
Date: Wed, 05 Jun 2002 01:49:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFD5222.1070007@fl.priv.at>
References: <5.1.0.14.2.20020604123917.06a1ac50@mail.harddata.com>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> 
> Question: Is there a way to rescan IDE bus to recognise a new drive?


With a "normal" IDE controller my best guess would be:

# hdparm -h 2>&1|grep DANGER
  -r   get/set readonly flag (DANGEROUS to set)
  -R   register an IDE interface (DANGEROUS)
  -U   un-register an IDE interface (DANGEROUS)
  -w   perform device reset (DANGEROUS)
  -W   set drive write-caching flag (0/1) (DANGEROUS)
  -x   perform device for hotswap flag (0/1) (DANGEROUS)


-- 
MfG / Regards
Friedrich Lobenstock

