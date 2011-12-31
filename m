From: Steve Carlson <stevengcarlson@gmail.com>
Subject: Re: RAID0 partition set to spare
Date: Fri, 30 Dec 2011 21:03:48 -0600
Message-ID: <CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
	<4EFD9956.5050703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFD9956.5050703@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Hi Steve,
>
> Posting the error messages like this is great - certainly works for me.
>
> Looking at your error messages, I am not overly optimistic for you
> unfortunately :( It looks to me like your sdb has some bad sectors on it
> (even though smart claims it passed), and it therefore is unable to read
> the raid metadata on /dev/sdb3 :( Note that the error counts on both
> drives are *very* high, at least compared to the drives I have here.
>
> Could you try and run this:
>
> mdadm --stop /dev/md2
> dmesg -c (this clears the dmesg log)
> mdadm --assemble /dev/md2 /dev/sd[ab]3
>
> then post the output from dmesg? I'd like to see if you get read errors
> at this exact point.
>
> Unless there is a secondary backup of the metadata elsewhere on the
> partition, or you can force/trick mdadm into ignoring the metadata on
> sdb3 and rely solely on the info found on sda3 (however I am not sure if
> this is possible), then I suspect you are out of luck.
>
> Neil may have some ideas for this.
>
> I presume you tried letting the system shut down and cool off completely
> before trying to bring it back up? Just in case it has been running very
> hot for a long time?
>
> Cheers,
> Jes

Hi Jes,

The system has mostly been sitting powered down while I'm not trying
to fix it.  Both drives reporting 37c temps right now.

mdadm --stop /dev/md2 && dmesg -c && mdadm --assemble /dev/md2 /dev/sd[ab]3
http://dl.dropbox.com/u/2776371/raid/mdadm_stop_dmesg_c_mdadm_assemble.txt

I also ran extended self tests just to be thorough, and they both came
back error free.  I'm unsure as to whether that puts them in the clear
for bad sectors though.

smartctl --test=long /dev/sda
http://dl.dropbox.com/u/2776371/raid/smartctl_test_long_sda.txt

smartctl --test=long /dev/sdb
http://dl.dropbox.com/u/2776371/raid/smartctl_test_long_sdb.txt

-Steve
