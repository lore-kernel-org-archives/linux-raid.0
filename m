From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 09:40:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407071340.i67DeJ307800@watkins-home.com>
References: <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
To: stephen@exitwound.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You did not use the "missing" keyword.  You just created a 3 disk array.  If
your array had 3 disks, you should have listed 2 of them and the "missing"
keyword for the third.  Why did you add a spare(hde1)?

I am guessing your array had 4 disks.  You should have done something like
this:
mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/hdg1 /dev/hdd1
/dev/hdc1 missing
Note the "--raid-devices=4" and "missing".

I think your data is gone.  At least 1/3 or 1/4 of it.

Which ever disk it is rebuilding to, has been trashed!
Stop the array and re-create it, but this time list the disk as missing.  Do
this command to determine which disk is being re-built:
cat /proc/mdadm
You must do this before the re-build is finished!

Guy



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Stephen Hargrove
Sent: Wednesday, July 07, 2004 9:24 AM
To: Luca Berra
Cc: linux-raid@vger.kernel.org
Subject: Re: Should I Start Over?

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

