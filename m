From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: maximum size
Date: Tue, 04 Oct 2005 12:16:25 +0200
Message-ID: <43425679.3050601@bppiac.hu>
References: <43394753.9040107@bppiac.hu>	<17209.18879.583532.761762@cse.unsw.edu.au>	<43394E4E.4060702@bppiac.hu>	<17210.23249.826375.668486@cse.unsw.edu.au>	<Pine.LNX.4.62.0509280826170.6259@chaos.egr.duke.edu> <17217.49985.339220.524306@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17217.49985.339220.524306@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday September 28, jlb17@duke.edu wrote:
> 
>>On Wed, 28 Sep 2005 at 10:56am, Neil Brown wrote
>>
>>
>>>On Tuesday September 27, lfarkas@bppiac.hu wrote:
>>
>>>>suppose i create the raid device with:
>>>>mdadm --create /dev/md0--level=5 --raid-devices=8 --spare-devices=1
>>>>/dev/sd[abcdefgh]1
>>>>then what is the maximum size for /dev/md0?
>>>>(or more precisely after a mkfs.ext3 /dev/md0).
>>>
>>>The /dev/sdX1 cannot be larger than 2TB.  The /dev/md0 can be as big
>>>as you like.  The filesystem can be as big as your filesystem allows.
>>>I don't think ext3 can exceed 2 TB (I could be wrong).  Other
>>
>>RH (e.g.) officially supports ext3 FSs up to 8TB in RHEL4.
> 
> 
> See... I was wrong!  :-)
> 
> I'm sure there is a 32bit limit somewhere, so it's probably that block
> addresses are limited to 32 bits.  With 4K blocks, that's 2^34 K, or
> 16TB.... Maybe there is some confusion with the sign bit, making it on
> 2^33K, or 8TB.

i already find the trivial source kernel/Documentation/filesystems/ext2.txt:
---------------------------------
Filesystem block size:     1kB        2kB        4kB        8kB

File size limit:          16GB      256GB     2048GB     2048GB
Filesystem size limit:  2047GB     8192GB    16384GB    32768GB
---------------------------------


-- 
   Levente                               "Si vis pacem para bellum!"

