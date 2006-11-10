From: Mogens Kjaer <mk@crc.dk>
Subject: Re: Swap initialised as an md?
Date: Fri, 10 Nov 2006 12:55:57 +0100
Message-ID: <455468CD.2050305@crc.dk>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David wrote:
...
> My aim was to have the two swap partitions both mounted, no RAID (as I 
> didn't see any benefit to that, but if I'm wrong then I'd appreciate 
> being told!). 

If one of your disks fails, and you have pages in the swapfile
on the failing disk, your machine will crash when the pages are
needed again.

Mogens

-- 
Mogens Kjaer, Carlsberg A/S, Computer Department
Gamle Carlsberg Vej 10, DK-2500 Valby, Denmark
Phone: +45 33 27 53 25, Fax: +45 33 27 47 08
Email: mk@crc.dk Homepage: http://www.crc.dk
