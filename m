From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Which filesystem for a hybris raid1?
Date: Sat, 28 Sep 2013 14:18:05 -0300
Message-ID: <CAH3kUhEM64Et5_Ch06XSnEG0G6YhZ0OwCD1=O0-q5XZB7Zpmyw@mail.gmail.com>
References: <5246E543.1030201@hanswkraus.com>
	<CAH3kUhF4RDMgkCcowTnFEAU5AfRLpah9Lrx5qqfmPLPNJjwnmA@mail.gmail.com>
	<52470C24.7060504@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52470C24.7060504@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi Hans!
well, this was discussed some times here, and i tested something like it
well if you want more secure disk, use raid 1,5,6
if you want speed use cache (bcache, flashcache, dm cache)

the write behind will not give a lot of speed, i think that a raid1
with hdd + ssd as cache is better, but didn't tested yet, i have a
revodrive here, and it have two devices (sda/sdb) this could allow a
raid1-hdd raid1-ssd and give secure at cache side...

maybe others guves have more ideas here...

Sans told me to buy a raid hardware with cache and bbu, it's better
than a raid1 + sdd as cache, i didn't cehcked yet... but probably i
will do

2013/9/28 Hans Kraus <hans@hanswkraus.com>:
>
> Am 28.09.2013 17:28, schrieb Roberto Spadim:
>> what hybrid means?
>> [...]
>
> An SSD and a conventional HD as mdadm Raid 1, the conventional HD
> added with '--write-behind --write-mostly' during the mdadm create.
>
> Regards, Hans
>
> (Sorry, forgot the list during my first reply)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
