From: Mike Hardy <mhardy@h3c.com>
Subject: Re: md Grow for Raid 5
Date: Tue, 08 Mar 2005 15:20:50 -0800
Message-ID: <422E3352.20002@h3c.com>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu> <422DFE60.5020807@weisshuhn.de> <422E1C6A.2000006@h3c.com> <422E31F3.3070104@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <422E31F3.3070104@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: Frank Wittig <fw@weisshuhn.de>, John Poirier <john.poirier@case.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


berk walker wrote:
> Have you guys seen/tried mdadm 1.90?  I am delightfully experiencing the 

I believe the mdadm based grow does not work for raid5, but only for 
raid0 or raid1. raidreconf is actually capable of adding disks to raid5 
and re-laying out the stripes / moving parity blocks, etc

You're very correct about needing to grow the FS after growing the 
device though. Most FS's have tools for that, or there's LVM...

-Mike
