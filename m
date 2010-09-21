From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: a general question re. linux-raid stability
Date: Tue, 21 Sep 2010 14:19:55 +1200
Message-ID: <1285035595.5101.176.camel@localhost.localdomain>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com>
	 <20100918210920.E05AE157D71@gemini.denx.de>
	 <7707889dee57e97ad50b4ce5c7697466@mail.gmail.com>
	 <4C97DFB4.1010705@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C97DFB4.1010705@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2010-09-20 at 18:27 -0400, Miles Fidelman wrote:
> Folks,
> 
> I've been watching patch after patch go by on this list, which leads me 
> to wonder - how stable are the basic raid kernel modules, and mdadm, as 
> included in major linux distributions (in my case, Debian Lenny)?  I 
> can't recall seeing either md or mdadm updates propagate through the 
> packaging system.  Should I be worried about my production machines?
> 
I've been running stock Lenny with Raid1 and Raid5 on a number of
servers using the stock Lenny tools with no problems.  I think it's safe
that unless you reshape (add disks or change levels  ie; raid5 to raid6
etc.  If you do this you really then should get the latest and greatest
kernels and mdadm package and make sure you have a good backup and are
not relying on your server before doing anything).  The biggest issue is
actually booting working properly as grub2's raid support is a bit
broken for some scenarios.

Regards,
-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722




