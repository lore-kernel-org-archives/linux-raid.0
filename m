From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Tue, 27 Jul 2004 23:09:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040728030927.GA1625@jim.sh>
References: <20040727021209.GA19205@jim.sh> <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net> <20040727172028.GA27240@jim.sh> <20040727181938.GA28181@jim.sh> <20040727184836.GA28494@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040727184836.GA28494@jim.sh>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> And here's a trace showing problems even without a filesystem.
> Writing data near the end is fatal.  This does not happen if I write
> to the first 1G of the array.

Sorry, that test was bogus, and I needed to learn how to use mdadm. 
I haven't actually managed to cause corruption on a raw device with no
filesystem.  However, copying a single 200MB file onto Reiserfs will
cause corruption.  It takes a lot more work (e.g. actually copying an
installed system onto it), but XFS shows eventual corruption as well,
so it's not specific to the filesystem type.

I see no problems if I start the array with a complete set of disks;
the corruption only happens if it starts degraded (tested with both 1
and 2 disks missing, and with the missing disks being at both the
beginning and the end).  This happens on Linux 2.6.3 and 2.6.7, with
mdadm 1.5.0 and 1.4.0, with and without CONFIG_LBD.  RAID-5 works
correctly in all tested configurations.  I have tried varying the
number of disks in the array.

Interestingly, if I start it with all disks, it starts reconstructing
immediately.  If I start it with only one disk missing, it does not
reconstruct anything.  Shouldn't it be creating one of P or Q?

-jim
