From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 03:10:33 +0200
Message-ID: <62b0912f0604161810m71cf0086h47a05699b02bc43e@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
	 <62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
	 <17474.59005.812914.343869@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.59005.812914.343869@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> > How do I force MD to raise the event counter on sdb1 and accept it
> > into the array as-is, so I can avoid bad-block induced data
> > corruption?
>
> For that, you have to recreate the array.

Scary.  And hairy.
How much do I have to bribe you to make this work:

# mdadm --assemble /dev/md1 --force  /dev/sd{a,b,c,d,e,f}1

Not now, that is, but for the sake of future generations? :)

> Make sure you get the
> chunksize,  parity algorithm, and order correct, but something like
>
>   mdadm -C /dev/md1 --assume-clean /dev/sda1 /dev/sdb1 /dev/sdc1 \
>       /dev/sdd1 /dev/sde1 /dev/sdf1

How do I backup the MD superblocks first so I can 'dd'-restore them in
case the above command totally wrecks the array because I got it
wrong?

It's an old array, so it's version 00.90.00 superblocks - does that
make a difference?

> and then
>   echo check > /sys/block/md1/md/sync_action
>
> and see what
>    cat /sys/block/md1/md/mismatch_count
> reports at the end.
> Then maybe 'echo repair > ....'

Super, thanks as always for your kind help.

(After examining the syslog, I think that there might be a bug, or not
- I'll start a new thread about that.)
