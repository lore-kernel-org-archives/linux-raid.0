From: Neil Brown <neilb@suse.de>
Subject: Re: Partitions with == or \approx same size ?
Date: Sat, 21 Jul 2007 17:02:27 +1000
Message-ID: <18081.44931.299829.724158@notabene.brown>
References: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
	<18081.11720.547650.571674@notabene.brown>
	<Pine.LNX.4.58.0707210235000.30683@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Seb on Saturday July 21
Sender: linux-raid-owner@vger.kernel.org
To: Seb <seb@h-k.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 21, seb@h-k.fr wrote:
> 
> Hi Neil,
> 
> 
> | > Could you tell me if such a mechanism exists in mdadm?
> | > Or should I accept the "loss" of the 150 GB?
> | When you give mdadm a collection of drives to turn into a RAID array,
> | use bases the size of the array on the smallest device.
> 
> I'm sorry I don't know what "bases" are in a RAID array and I can't find
> this term in the man page. Could you elaborate?

Typo.  Should be
    It bases the size of the array ...

i.e. it works out which is the smaller device, and uses that size to
determine the size of the array.  e.g. if you are making a raid5 with
4 drives, then the array will be 3 times the size of the smallest array.

> 
> | You might want to make it a little smaller still in case you have to
> | replace a device with a slightly smaller device (it happens).  You can
> | use "--size" to reduce the used space a little further if you like.
> 
> Thanks for the pointer to --size! I had overlooked this option. The man
> page says that "If  this is not specified (as it normally is not) the
> smallest drive (or partition) sets the size". This implies that partitions
> need not have exactly the same size and 'mdadm' will still manage.

Exactly.

> 
> So I'll use 249,9GB out of 250GB, skip over the small resulting
> differences, let mdadm work its magic and when new disks will be inserted
> after a failure it will suffice to use their total space.

Again, exactly correct.

NeilBrown
