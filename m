From: Jeremy Thompson <jeremythompson82@gmail.com>
Subject: It is safe to stop Raid being reshaped
Date: Wed, 28 Dec 2011 09:55:43 -0800
Message-ID: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I added an extra drive to an existing Raid 5 array which consisted of
6 drives, now of course with the additional drive it will make it 7.
However, the speed of the reshape is going at 8877K/sec and sometimes
goes into 9000K/sec range however it does not go above this.

I've changed all the parameters to make it go faster for the reshaping
process which includes /proc/sys/dev/raid/speed_limit_min and
/proc/sys/dev/raid/speed_limit_max.

These were changed to 50000 each.  That did not help.  I then made
another change which was blockdev --setra 16384 /dev/md0.

Again nothing changed.  However, I do think that my drives are too
close to each other causing more heat and possibly causing issues with
the reshaping process due to some of the errors I see in the log
files.  I see some of the drives complaining about being hard reset.

I was dumb and stacked them pretty close to each other and before
since they were not under heavy use, there were no problems... however
now that the drives are under heavy use... I am seeing these errors
come up. I'd like to re-arrange the drives so they have more airflow
and also help try and prevent the errors from showing.  So with that
in mind, would it be at all possible to stop the reshaping process,
re-arrange the drives, then get the reshaping process back up and
running?

Or would it be better for me to just wait until the reshaping process
is completed?  Right now I'm look at another day to complete the
process.  If all goes well and I think it will... (first time doing
this) I would like to add another drive to the array however, I don't
want this to be my experience every time I add an additional drive to
it.  I am a bit new to Linux so if I got some of the terminology wrong
please forgive me.

Oh, and if there is a way to stop the reshape process safely and have
it restart after re-arranging of the drives, please let me know the
proper procedure to this being done.

Thanks for everyone taking their time reading this and any help anyone
can provide.

-Jeremy
