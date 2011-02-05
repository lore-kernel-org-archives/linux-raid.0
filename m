From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: raid1 new read balance, first test, some doubt, can anyone help?
Date: Sat, 5 Feb 2011 12:44:36 +0100
Message-ID: <20110205114436.GA14930@www2.open-std.org>
References: <AANLkTikEK3JuE-XXb=F--N0KcTiB2zW+_gq-6e199kRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikEK3JuE-XXb=F--N0KcTiB2zW+_gq-6e199kRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Roberto

Just a little advice:

IMHO raid1 is old technology, you should rather look at the raid10
driver, which can do the same as raid1, but also do some other stuff.

best regards
keld


On Sat, Feb 05, 2011 at 03:38:22AM -0200, Roberto Spadim wrote:
> hi i make a read balance select (via sysfs), could anyone help me to debug it?
> the new/old code is located at:
> http://www.spadim.com.br/raid1/
> it's kernel 2.6.37 based
> 
> =============================================
> i don't know if exist a function at per mirror bio queue that return
> the sum of write sectors, sum of read sectors, the first and last
> sector position in queue
> if anyone know please help me, i will use it at
> line: 510 raid1.new.c
> time_based_current_queue_time = 0;
> 
> all information is in the same line
> 
> =============================================
> i don't know how to read information per mirror
> for example, at raid1.h
> i have some variables:
>         int             head_distance_rate;     /* used by time based,
> time=(this_sector - head_position) * head_distance_rate */
>         int             read_sectors_rate;      /* used by time based,
> time=sectors * read_sectors_rate */
>         int             write_sectors_rate;        /* used by time
> based, time=sectors * write_byte_rate   */
> 
> i would make it per mirror, for example:
> 
> /sys/block/md0/md/sda1_head_distance_rate -> head_distance_rate
> /sys/block/md0/md/sda1_read_sectors_rate -> read_sectors_rate
> /sys/block/md0/md/sda1_write_sectors_rate -> write_sectors_rate
> 
> anyone know how to do it?
> how could i compile the raid1.c and raid1.h to test?
> my today raid1 is a module at my current kernel, but i couldn't (i
> don't know how) compile it and use :/ it's my first kernel driver :)
> hehe
> 
> 
> 
> -- 
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
