From: "Vlad Milovanovic" <vlad@webmail.co.za>
Subject: Re: promise sx6000 success / raid options
Date: Mon, 28 Oct 2002 10:06:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210280806.g9S86L220650@mailgate.mailbox.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The stride option will, or should, inform the MD driver of the number
of blocks that will fit in the single RAID stripe. To be useful, you
have to fdisk the partition as Linux raid (I am sure that you have
done this already, as it is the only way to autodetect). I am not sure
how you have set up your filesystem, since you mention ext3 slowing
things down and then using mke2fs???

ext3 will not slow things down noticeably. I also don't know what type
of disks and how many disks you are using, but 15 MB/s seems very
slow. You have also not specified what RAID level you are using, so it
is difficult to say what your performance should be (ballpark figure).

Maybe you can post some more detailed specs, and then we can look into
it more closely.

But to answer your question, I have found stride option to make a huge
impact in RAID 5 setups. Also, depending on what kind of system you
are running, you may want to look into using the -T largefile (or some
other) option, to let the filesystem reduce (or increase) the number
of inodes that you have created. You should pay attention to the way
that the RAID will be accessed most frequently, as you can use the
many available options in mkfs and raidtab to your advantage to
optimize your RAID for its particular purpose.

Hope this helps,
Cheers,

Vlad.


On Sat, 26 Oct 2002 14:35:58 +0200 (CEST) Mikael Abrahamsson
(swmike@swm.pp.se) wrote:

>
>I had initial problems with a Promise SX6000 controller with the i2o
block
>driver and I also tried their source pti_st.o code but never got it
to
>compile. I emailed promise and got a response back quite quickly
which
>provided me with a new version of the source code version, plus beta
>drivers they themselves compiled for redhat 7.3 and redhat 8.0
kernels.
>
>I have today started using the redhat 8.0 kernel driver and it seems
to
>work very well. Write performance is approx 15 meg/s to a 5 times
120gig
>drive stripe (seems a bit on the low side if you ask me but that's ok
>anyway, perhaps ext3 is slowing things down). I recommend anyone who
have
>problems with their SX6000 to do the same.
>
>I made the filesystem with just mke2fs -j and no raid options, is the
>"stride" options anything I should use? Does it provide better
>performance? (I tried finding some information on this, but the
mke2fs man
>page is so spread that all the search engines give me are copies of
the
>man page).
>
>--
>Mikael Abrahamsson    email: swmike@swm.pp.se
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

//--------------------------------------
Vlad Milovanovic
vlad@webmail.co.za
_______________________________________________________________
 http://www.webmail.co.za the South-African free email service
