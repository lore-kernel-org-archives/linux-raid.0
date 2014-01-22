From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 14:46:12 +0100
Message-ID: <52DFCBA4.5020106@shiftmail.org>
References: <20140121073540.GF10140@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121073540.GF10140@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/01/2014 08:35, Marc MERLIN wrote:
> Howdy,
>
> I'm setting up a new array with 5 4TB drives for which I'll use dmcrypt.
>
> Question #1:
> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
> (raid5 first, and then dmcrypt)

Crypt above, or you will need to enter the password 5 times.
Array checks and rebuilds would also be slower
And also, when working at low level with mdadm commands, it would 
probably be too easy to get confused and specify the underlying volume 
instead of the one above luks, wiping all data as a result.


> Question #2:
> In order to copy data from a working system, I connected the drives via an external
> enclosure which uses a SATA PMP. As a result, things are slow:
>
> md5 : active raid5 dm-7[5] dm-6[3] dm-5[2] dm-4[1] dm-2[0]
>        15627526144 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
>        [>....................]  recovery =  0.9% (35709052/3906881536) finish=3406.6min speed=18939K/sec
>        bitmap: 0/30 pages [0KB], 65536KB chunk
>
> 2.5 days for an init or rebuild is going to be painful.
> I already checked that I'm not CPU/dmcrpyt pegged.
>
> I read Neil's message why init is still required:
> http://marc.info/?l=linux-raid&m=112044009718483&w=2
> even if somehow on brand new blank drives full of 0s I'm thinking this could be faster
> by just assuming the array is clean (all 0s give a parity of 0).
> Is it really unsafe to do so? (actually if you do this on top of dmcrypt
> like I did here, I won't get 0s, so that way around, it's unfortunately
> necessary).

Yes it is unsafe because raid5 does shortcut rmw , which means it uses 
the current, wrong, parity to compute new parity, which will also come 
out wrong  . The parities of your array will never be correct, so you 
won't be able to withstand a disk failure.

You need to do the initial init/rebuild, however you can start writing 
to the array now already, but keep in mind that such data will be safe 
only after the fist init/rebuild has completed.


> I suppose that 1 day-ish rebuild times are kind of a given with 4TB drives anyway?

I think around 13 hours if your connections to the disks are fast.


> Question #3:
> Since I'm going to put btrfs on top, I'm almost tempted to skip the md raid5
> layer and just use the native support, but the raid code in btrfs still
> seems a bit younger than I'm comfortable with.

Native btrfs raid5 is WAY experimental at this stage. Only raid0/1/10 is 
kinda stable at this stage.


