From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [RFC PATCH 0/4] md/mdadm: introduce request function mode support
Date: Wed, 18 Jun 2014 16:43:27 +0200
Message-ID: <53A1A58F.8080407@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>	<1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>	<53A040B5.5050008@profitbricks.com>	<CAH3kUhEK26+4KryoReosMt654-vcrkkgkxaW5tKkFRDBqgX82w@mail.gmail.com>	<53A14513.20902@profitbricks.com> <CAH3kUhEGFycAOh5_HeQ0piVZCSisQ+kw9gNTDQjkt7rDxwx24A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhEGFycAOh5_HeQ0piVZCSisQ+kw9gNTDQjkt7rDxwx24A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sounds good but also completely unrelated. You should really post a new
thread for this and not using the request function mode support topic.

On 18.06.2014 15:57, Roberto Spadim wrote:
> Just a comment about the read balance:
> i'm talking about a  /sys/block/mdX/queue/read_balance
> today we have 'near head', we can do some read balances like freebsd,
> but that's what i'm thinking about:
> cat  /sys/block/mdX/queue/read_balance:
> [nearhead] roundrobin timebased stripe
> 
> ------------
> NEARHEAD:
>   today read balance, each write/read, mark the position of disk
> 'head', sequencial reads are done by the same disk, non sequencial
> reads select the disk with min(current position - read position) value
>   here i'm thinking about debugging, we could implement some sys files
> 
> cat /sys/block/mdX/queue/nearhead_info:
> 
> /dev/sda1 (device 1) - current position: xxxx
> /dev/sda2 (device 2) - current position: xxxx
> /dev/sda3 (device 3) - current position: xxxx
> ...
> 
> 
> ------------
> ROUNDROBIN:
>   select the disk based on reads/disk, current disk and current disk
> reads, here some configurations:
> 
> cat /sys/block/mdX/queue/roundrobin_info
> 
> /dev/sda1 (device 1) - reads count: xxxxx, max reads: yyyyy, current disk
> /dev/sda2 (device 2) - max reads: yyyyy
> /dev/sda3 (device 3) - max reads: yyyyy
> 
> MAX READ VARIABLE:
> cat /sys/block/mdX/queue/roundrobin_maxreads_dev1
> yyyyy
> echo 1234 > /sys/block/mdX/queue/roundrobin_maxreads_dev1
> cat /sys/block/mdX/queue/roundrobin_maxreads_dev1
> 1234
> 
> READ COUNT VARIABLE:
> cat /sys/block/mdX/queue/roundrobin_readcount_dev1
> xxxxx
> echo 1234 > /sys/block/mdX/queue/roundrobin_readcount_dev1
> cat /sys/block/mdX/queue/roundrobin_readcount_dev1
> 1234
> 
> CURRENT DISK VARIABLE
> cat /sys/block/mdX/queue/roundrobin_currentdevice
> xxxxx
> echo 1 > /sys/block/mdX/queue/roundrobin_currentdevice
> cat /sys/block/mdX/queue/roundrobin_readcount_dev1
> 1
> 
> 
> ----------------
> STRIPE:
>    it's something like raid0, each disk read one part of the array
> 
> /sys/block/mdX/queue/stripe_array_shift
>    this one, select how many bytes/sectors, per disk, for exaple, from
> 0-100 disk 1, 101-200 disk 2, 201-300 disk 3, 301-400 disk 1, 401-500
> disk 2 .... etc, that's just a number of how many sectors/bytes per
> disk
> 
> 
> ---------------
> TIME BASED:
>  this one, is more specific per disk, and we can mix ssd and hdd, it's
> just a standard model and can change, but it give 1% of speed up with
> ssd+hdd arrays
> 
> the expected time to read is:
>   (read_rate_sequencial * read_size) +
>   (head_distance_rate * head_distance) +
>   fixed_access_time_non_sequencial +
>   fixed_access_time_sequencial +
>   queue_expected_time
> 
> a example for hd:
> read_rate_sequencial = 180mb/s  (must invert since we need s/mb)
> head_distance_rate = 10ms/total_disk_size
> fixed_access_time_nonsequencial = ~10ms (1 disk rotation, this can be
> disk rpm => 7200rpm = 120hz, 1/120 = 0.008333 seconds)
> fixed_access_time_sequencial = 0
> queue_expected_time = (must check queue if we could get this information)
> 
> for ssd:
> read_rate_sequencial = 270mb/s
> head_distance_rate = 0
> fixed_access_time_sequencial = 0,1ms (ocz vertex 2 )
> fixed_access_time_non_sequencial = 0,1ms (ocz vertex 2 )
> 
> 
> examples with 20MB, considering disk at current position:
> hd:
>   (0.0055555 * 20) +    (180mb/s = 0.00555s/mb)
>   (0.000009765625 * 0) +    (considering 1tb disk => 10ms/1024gb,
> 10ms/1024000mb = 0.000009765625mb/ms)
>   0 +
>   0
>   =0.11111 second, (just mb/s matters here)
> 
> 
> ssd:
>   (0.0037037037037037 * 20) +  (270mb/s = 0.0037037037037037s/mb)
>   (0 * 0) +  (0ms / total ssd size = 0)
>   0,0001  (0,1ms)
>   = 0.0740 second (mb/s + access time of 0,0001second)
> 
> 
> for small reads, this model select hd when it's near head position,
> for bigger reads it select ssd, if we could consider queue of ssd and
> hdd, we have a better read time prediction, it does a nice work (1% of
> speedup) but have many parameters / disk
> 
> -------
> there's an old implementation at raid1.c here:
> http://www.spadim.com.br/raid1/raid1.c
> 

