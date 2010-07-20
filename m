From: Neil Brown <neilb@suse.de>
Subject: Re: BUG REPORT: md RAID5 write throughput will drop for 1~2s every
 16s  (under 1Hz sample rate)
Date: Tue, 20 Jul 2010 22:43:27 +1000
Message-ID: <20100720224327.69ff1967@notabene>
References: <AANLkTin4T27FUSAWktl-gAHm1yseXcIMTc-7WEPkCOu6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4T27FUSAWktl-gAHm1yseXcIMTc-7WEPkCOu6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 20 Jul 2010 19:40:05 +0800
Eddy Zhao <eddy.y.zhao@gmail.com> wrote:

> Hello Neil:
> 
> 
> We observe periodic write throughput drop of md RAID5. See description below
> 
> Configuration
>  - linux 2.6.28.9
>  - 3 Seagate 320GB 7200rpm SATA2.0 disks
>  - md RAID5, 3 disks, 256KB chunk
> 
> Test
>  - open O_DIRECT /dev/md0
>  - sequential write, 512KB write block
>  - refer to "fpt.cpp" ("ulimit -s ulimited" before run the program)
> 
> Problem
>  - md RAID5 write throughput will drop for 1~2s every 16s (under 1Hz sample
> rate)
>  - refer to "output.txt"
> 
> Do you know the resaon of the problem? We want to fix it on our server to
> make the QOS smooth

If I'm interpreting your numbers correctly, it is just an occasional single
write that is slow - not a series of writes during a one second interval that
are each slow.  It would help if you could confirm that.

Two possibilities occur to me, though it could be something else altogether.
You would need to instrument the code to collect internal states to see if it
is one of these or something else.

1/ a scheduler problem could be delaying the running of raid5d from time to
   time so that it either doesn't respond to ready stripes quickly, or cannot
   get CPU time to perform the xor.

2/ For some reason raid5 sometimes decides that it needs to pre-read the
   'other' block to calculate parity rather than waiting for the other block
   to be written.  This is more likely.
   Either this is bad code somewhere, or the raid5 is being 'unplugged'
   prematurely.
   This seems to happen with a period of 30 seconds (I don't know where you
   got 16 from.  The command:
     tr : ' ' < output.txt | sed 's/ms//' | awk '$4 > 100 {print NR, NR-p; p=NR}' 
   suggests intervals of 1 or 33 seconds being most common, though you could
   get more precise data out of your program.

   I suspect this aligns with the 30 second periodic 'flush' that Linux does,
   though I'm not 100% certain.  You could possibly put a 'WARN_ON' in 
   raid5_activate_delayed if delayed_list is not empty.  That will give you
   a stack trace showing why the unplug was called.

I'd be keen to hear about any further discoveries you make.

BTW I prefer all such questions be post to linux-raid@vger.kernel.org
as others may be able to contribute.  I have taken the liberty of 
cc:ing this reply there.  I hope you are OK with that.


NeilBrown


> 
> FYI: "Single disk" and "2 disk RAID0" write throughput are all smooth (under
> 1Hz sample rate)
> 
> 
> Thanks
> Eddy

