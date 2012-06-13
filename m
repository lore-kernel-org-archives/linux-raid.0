From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: metadata versions: 0.90 vs 1.2
Date: Wed, 13 Jun 2012 07:46:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1206130744440.25054@uplift.swm.pp.se>
References: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: plug bert <plugbert@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Jun 2012, plug bert wrote:

> Is this expected behavior? Are there any potential problems if i stick 
> with metadata=0.90(apart from the 28 device and 2Tb disk space limit)?

From "man mdadm":

               1, 1.0, 1.1, 1.2 default
                      Use  the  new  version-1  format superblock.  This has few restrictions.  The different sub-versions store the superblock at
                      different locations on the device, either at the end (for 1.0), at the start (for 1.1) or 4K from the start (for 1.2).   "1"
                      is equivalent to "1.0".  "default" is equivalent to "1.2".

If you want to be able to mount the individual RAID1 members but still use 
the newer version superblock, you need to use version 1.0 (stored at the 
end of the device/partition).

I'd recommend to go with 1.0 instead of 0.90.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
