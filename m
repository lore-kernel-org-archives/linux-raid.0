From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm can't reshape/resize arrays
Date: Thu, 25 Jun 2009 08:07:13 +1000 (EST)
Message-ID: <b1d80cbeaf61f9b8496e31f0a57df951.squirrel@neil.brown.name>
References: <878wjh4qt1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878wjh4qt1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, June 25, 2009 1:03 am, Goswin von Brederlow wrote:
> Hi,
>
> I'm trying to resize/reshape some of my arrays:
>
> md1 : active raid1 sdc5[1]
>       9767424 blocks [2/1] [_U]
>       bitmap: 48/150 pages [192KB], 32KB chunk
>
> % mdadm --grow --size max /dev/md1
> mdadm: Cannot set device size for /dev/md1: Device or resource busy
>
> and dmesg says:
>   md: couldn't update array info. -16
>
>
> md2 : active raid5 sdc2[6](S) sde2[3] sdg1[1] sdf3[4] sdd1[5] sdb1[2]
> sda1[0]
>       945625280 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>       bitmap: 0/181 pages [0KB], 512KB chunk
>
> % mdadm --grow -n 7 /dev/md2
> mdadm: Need to backup 1920K of critical section..
> mdadm: Cannot set device size/shape for /dev/md2: Device or resource busy
>
> and dmesg says:
>   md: couldn't update array info. -16
>
>
> % uname -a
> Linux frosties 2.6.29.4-frosties-1 #8 Sun Jun 7 00:48:55 CEST 2009 x86_64
> GNU/Linux
>
> % mdadm --version
> mdadm - v2.6.9 - 10th March 2009
>
>
> Anyone have an idea what is wrong there?

md cannot grow arrays with bitmaps as it is not able to grow the bitmap.
You need to remove the bitmap, grow the array, then add the bitmap.
And unfortunately you cannot add the bitmap until the grow
has finished.

Yes, there is room for improvement here.

NeilBrown

