From: Luca Berra <bluca@comedia.it>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Mon, 17 Nov 2003 21:24:58 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031117202457.GC11443@percy.comedia.it>
References: <3FB75992.3020608@bnap.hu> <20031117092922.GD30745@percy.comedia.it> <16312.39435.330127.598268@notabene.cse.unsw.edu.au> <3FB8D5A6.4040909@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FB8D5A6.4040909@bnap.hu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 17, 2003 at 03:05:26PM +0100, Farkas Levente wrote:
>>Not so weird - it is exactly what I was going to suggest.
>>Providing you get the chunk size, parity algoithm and device order
>>right, and use "--force" to make sure mdadm doesn't re-arrange the
>>devices on on it should work perfectly.
>
>this's one of our production server, so I'd like to be sure. so:
this is the reason i said it is a weird idea, it is not easy to
understand and if you fuck up you fuck up badly!

>- switch the disk one by one (do these steps 8 times):
>   - put out one 120 hd (mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1)
>   - put the new 200 GB one and create a 200 GB partition (Linux raid
>     autodetect)
>   - add to md0 (mdadm -a /dev/hda1) this step do not change the device
>     order???
at this point you will find yourself with a 120GBx8 raid 5 array
now you would have to (but i would be very careful in doing this)

check the exact device order (/proc/mdstat ???)
write it down
check the chunk size
write it down
check the parity algorithm
write it down

umount the fs
stop the damned array

mdadm -C /dev/md<whatever> -c <your chink size> -p <your parity> -n 8 -f <list of all
devices in the same exact order>

THIS WILL REWRITE THE PARITY ON ALL DRIVES, SO IF YOU GET IT WRONG YOU
WILL DESTROY YOUR DATA

(would using missing as the last drive prevent the parity rebuild and
allow to check the expected result ?????)

cross you fingers,
mount your fs back and see what happened
umount it again
>- resize2fs
mount it for the last time


>when should I use --force??
only when you are really sure of what you are doing.

please test it on a test system before doing it on real data

you might well find that a slower way might be better for you

(i don't want to sound catastrophic, but i am not going to be held
responsible if someone reads these instruction and fucks-up badly)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
