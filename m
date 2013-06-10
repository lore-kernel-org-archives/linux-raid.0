From: Dominic Raferd <dominic@timedicer.co.uk>
Subject: Re: SSD + Rust as raid1
Date: Mon, 10 Jun 2013 09:57:02 +0100
Message-ID: <51B594DE.9090609@timedicer.co.uk>
References: <51A7C36F.4030605@timedicer.co.uk> <20130531133018.77cd9285@natsu> <51A85574.8080709@timedicer.co.uk> <20130531135434.5b6bdddb@natsu> <51A864E1.9070903@timedicer.co.uk> <51ADA1AF.6040405@timedicer.co.uk> <51B25D7C.4090403@tmr.com> <20130608162235.7ca32f4d@natsu> <51B365CA.6090409@tmr.com> <CAH3kUhFdYNpnnYYj+h_bcLDNC6U7tMySEYn012P7ZUTP0VXbZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFdYNpnnYYj+h_bcLDNC6U7tMySEYn012P7ZUTP0VXbZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/06/2013 22:58, Roberto Spadim wrote:
> check this, maybe could help to improve performace (it's not a raid1
> solution, it's a cache solution, in kernel 3.9):
>
> http://kernelnewbies.org/Linux_3.9#head-3dbc54b9324d21f06f55299b0a30d6cb06403529
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/plain/Documentation/device-mapper/cache.txt?id=c6b4fcbad044e6fffcc75bba160e720eb8d67d17
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks to all for input. I have abandoned the attempt to make this 
configuration work - I hit various error messages (latterly: 'Failed to 
RUN_ARRAY /dev/md0 invalid argument') so I am now running without RAID. 
I will look into the cache solution but more likely I will just rsync 
the SSD to the conventional platter disk at regular intervals. (I also 
run rdiff-backup daily to another machine.)

Dominic
-- 
*TimeDicer* <http://www.timedicer.co.uk>: Free File Recovery from Whenever
