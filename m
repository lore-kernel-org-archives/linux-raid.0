From: Farkas Levente <lfarkas@bnap.hu>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Mon, 17 Nov 2003 15:05:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FB8D5A6.4040909@bnap.hu>
References: <3FB75992.3020608@bnap.hu>	<20031117092922.GD30745@percy.comedia.it> <16312.39435.330127.598268@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16312.39435.330127.598268@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday November 17, bluca@comedia.it wrote:
> 
>>Really weird idea: please do not do it on real data.
>>You will probably shoot yourself doing this
>>- Switch the disks one by one.
>>- When you are over create a new raid5 over the existing one (keeping the
>>same settings for stripe size and parity algo)
>>- Resize the filesystem.
>>
> 
> 
> Not so weird - it is exactly what I was going to suggest.
> Providing you get the chunk size, parity algoithm and device order
> right, and use "--force" to make sure mdadm doesn't re-arrange the
> devices on on it should work perfectly.

this's one of our production server, so I'd like to be sure. so:
- switch the disk one by one (do these steps 8 times):
   - put out one 120 hd (mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1)
   - put the new 200 GB one and create a 200 GB partition (Linux raid
     autodetect)
   - add to md0 (mdadm -a /dev/hda1) this step do not change the device
     order???
- resize2fs

when should I use --force??

> Somewhere low-down on my todo list for raid is allowing this to be
> done on-line (mdadm /dev/md0 --size=max).  It is right along side

that's be nice:-)

> allowing the number of live devices in a raid1 to be changed 
> (mdadm /dev/md1 --devices=3) and adding devices to a linear array 
> (mdadm /dev/md2 --add /dev/sdd).

that would be useful for raid5 too?
yes I know the reason why this is not possible, BUT it can do (rebuild 
the whole raid5) the same as the create for raid5 and it can be run in 
the backgroup. that would be a very useful feature for many people.
yours.

-- 
   Levente                               "Si vis pacem para bellum!"


