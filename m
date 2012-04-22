From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Sun, 22 Apr 2012 19:21:11 +0200
Message-ID: <4F943E07.8040206@computer.org>
References: <4F92BC43.3010603@computer.org> <20120422070041.7e4b95e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120422070041.7e4b95e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> Looks like:
>
>     commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3
>
> is at fault.  It causes md to attempt to add spares into the array more often.
> Would I be right in guessing that you have one spare in this array?
> If you remove the spare, the messages should stop.

Hmmm. The commit message is as follows:

commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3
Author: NeilBrown <neilb@suse.de>
Date:   Fri Dec 23 10:17:53 2011 +1100

     md/raid5: If there is a spare and a want_replacement device, start 
replaceme

     When attempting to add a spare to a RAID[456] array, also consider
     adding it as a replacement for a want_replacement device.

     This requires that common md code attempt hot_add even when the array
     is not formally degraded.

     Reviewed-by: Dan Williams <dan.j.williams@intel.com>
     Signed-off-by: NeilBrown <neilb@suse.de>


Does this also apply to RAID1 (which is all I've got on this machine: no 
RAID456)?

Jan
