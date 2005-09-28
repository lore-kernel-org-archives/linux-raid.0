From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: maximum size
Date: Wed, 28 Sep 2005 08:27:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0509280826170.6259@chaos.egr.duke.edu>
References: <43394753.9040107@bppiac.hu> <17209.18879.583532.761762@cse.unsw.edu.au>
 <43394E4E.4060702@bppiac.hu> <17210.23249.826375.668486@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17210.23249.826375.668486@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Farkas Levente <lfarkas@bppiac.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Sep 2005 at 10:56am, Neil Brown wrote

> On Tuesday September 27, lfarkas@bppiac.hu wrote:

>> suppose i create the raid device with:
>> mdadm --create /dev/md0--level=5 --raid-devices=8 --spare-devices=1
>> /dev/sd[abcdefgh]1
>> then what is the maximum size for /dev/md0?
>> (or more precisely after a mkfs.ext3 /dev/md0).
>
> The /dev/sdX1 cannot be larger than 2TB.  The /dev/md0 can be as big
> as you like.  The filesystem can be as big as your filesystem allows.
> I don't think ext3 can exceed 2 TB (I could be wrong).  Other

RH (e.g.) officially supports ext3 FSs up to 8TB in RHEL4.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
