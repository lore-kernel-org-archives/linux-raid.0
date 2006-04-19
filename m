From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Re: Using LVM for RAID 1+0
Date: Tue, 18 Apr 2006 21:19:40 -0500
Message-ID: <6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
	 <17477.35448.136382.373967@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17477.35448.136382.373967@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/18/06, Neil Brown <neilb@suse.de> wrote:
> No, this is not correct.
> md/raid0 has no problem with devices being of different sizes.  It
> will make use of all the space doing as much striping as possible.

In that case, the other question would be if you can grow a RAID 0
array. Currently, one pair of disks have my remaining data. The idea
was to set the other pairs to RAID 1 arrays, link them with LVM (or
RAID 0) into one partition, copy the data, then convert the remaining
pair of disks to a RAID 1 array and grow the RAID 0 array to add the
additional RAID 1 array.

> However it sounds like your drive or your controller is not to be
> trusted.  There is a reason that it is failing.  Maybe raid5 triggers
> that reason more often, but that doesn't mean that raid1 won't
> trigger it at all.  I suggest you be very wary of your hardware!

Suspicious is the word for it. Which is why I'm not going back to RAID
5 using my current configuration. My drives are all external USB-2,
and split between some ports on front, some on back, and some on an
add-on card. My guess is that I had an arrangement that was swamping
the channels. I've played around with what is attached where in a
manner that appears to have "fixed' that.

FWIW,
Ewan
