From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Failed RAID5 array grow after reboot interruption; mdadm:  Failed
 to restore critical section for reshape, sorry.
Date: Tue, 17 Jun 2008 07:34:46 +1200
Message-ID: <4856C056.1000302@sauce.co.nz>
References: <C47BE76A.9030%jmolina@tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C47BE76A.9030%jmolina@tgen.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Molina <jmolina@tgen.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jesse Molina wrote:
> Thanks.  I'll give the updated mdadm binary a try.  It certainly looks
> plausible that this was a recently fixed mdadm bug.
> 
> For the record, I think you typoed this below.  You meant to say v2.6.4,
> rather than v2.4.4.  My current version was v2.6.3.  The current mdadm
> version appears to be v2.6.4, and Debian currently has a -2 release.

The latest version is 2.6.7

http://mirror.linux.org.au/linux/utils/raid/mdadm/

For some reason, Neil's http://www.cse.unsw.edu.au/~neilb/source/mdadm/ 
repository is not up to date.

Don't use 2.6.5 or 2.6.6 as they may cause segfaults.

Regards,

Richard
