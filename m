From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Fri, 19 Dec 2008 15:18:13 -0600
Message-ID: <cccedfc60812191318w18de5dfbs28bf476bd5d88359@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18761.54425.725696.255055@notabene.brown>
	 <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	 <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	 <18761.56537.935250.561921@notabene.brown>
	 <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
	 <18761.60380.938542.26851@notabene.brown>
	 <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
	 <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
	 <cccedfc60812191240m185d5f49td1ec2070c70c88e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812191240m185d5f49td1ec2070c70c88e4@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A correction: I used:

mdadm --assemble /dev/md11 --scan

to assemble md11.

> 6. --re-add /dev/nbd0
>
> At step 6, the array decided to go into recovery:
>
> Dec 19 14:32:26 turnip kernel: md: bind<nbd0>
> Dec 19 14:32:26 turnip kernel: RAID1 conf printout:
> Dec 19 14:32:26 turnip kernel:  --- wd:1 rd:2
> Dec 19 14:32:26 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
> Dec 19 14:32:26 turnip kernel:  disk 1, wo:0, o:1, dev:sda
> Dec 19 14:32:26 turnip kernel: md: recovery of RAID array md11
>
> and has some time to go ...
>
>      [=>...................]  recovery =  7.7% (6031360/78123988)
> finish=234.6min speed=5120K/sec

(I bumped the recovery speed up to it's maximum, FYI.)

Going off of the timestamps below, it took about 35 minutes to
recover. That's way faster than the more than 2 hours necessary for a
full sync. Therefore, I must assume that the bitmap is at least
partially working.

Dec 19 15:06:41 turnip kernel: md: md11: recovery done.
Dec 19 15:06:41 turnip kernel: RAID1 conf printout:
Dec 19 15:06:41 turnip kernel:  --- wd:2 rd:2
Dec 19 15:06:41 turnip kernel:  disk 0, wo:0, o:1, dev:nbd0
Dec 19 15:06:41 turnip kernel:  disk 1, wo:0, o:1, dev:sda

I'm going to re-do this experiment and grab an --examine-bitmap after
a minute or so into the rebuild to see what happens.

I am tentatively saying that the commit you suggested may be the root
cause of some of the "unnecessary full-sync" issues I've had.



-- 
Jon
