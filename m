From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Re: Should I Start Over?
Date: Wed, 7 Jul 2004 08:23:38 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
References: <1147.66.230.1.97.1088603162.squirrel@exitwound.org>
    <20040630165540.GA1099@percy.comedia.it>
    <1775.66.230.1.97.1088620939.squirrel@exitwound.org>
    <20040706210654.GB17694@percy.comedia.it>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040706210654.GB17694@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra said:
>
> you can try to see if you can read your data by recreating the array in
> degraded mode, so it does not rebuild.
>
> like:
> mdadm --create /dev/md0 --level=5 /dev/hdc1 /dev/hdd1 missing
> try substituting the word missing for each of the drives
> and see if you can mount the filesystem
> if you do find your data use:
> mdadm /dev/md0 -a <the device you replaced with missing>
> to have it added to the array again
>


Ok, I did the following:

# mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/hdg1 /dev/hdd1
/dev/hdc1
mdadm: array /dev/md0 started.
# mdadm /dev/md0 -a /dev/hde1
mdadm: hot added /dev/hde1
# mount /data
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hde1[4] hdc1[3] hdd1[1] hdg1[0]
      240121472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  0.2% (282348/120060736)
finish=2250.3min speed=884K/sec
unused devices: <none>

If I read your email correctly, I wasn't expecting this.  But I'm also
inexperienced enough to not really know what to expect.  All I know is
that I now have movement where, before, I had none.

So is this good or bad?  Is my data gone forever (I gave up on it a while
back, so if it's gone, it's gone)?

Thanks again, Luca.  You rock!

--
Steve
