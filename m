From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid1 recovery: reads and writes
Date: Mon, 15 Dec 2008 17:54:01 -0700
Message-ID: <e9c3a7c20812151654u5d644ccbv2c925a2fe2bc1c7e@mail.gmail.com>
References: <cccedfc60812150545s7159f0a2x2fa7f36ecf8d9c60@mail.gmail.com>
	 <18758.51053.866819.442495@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18758.51053.866819.442495@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 2:09 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> I have a software raid1 which underwent a recovery recently.
>> While it was recovering, I could not understand why I was seeing an
>> equal amount of *read* I/O as write I/O to the device the raid1 was
>> recovering to. That's to say, the raid1 was rebuilding on to a spare
>> but instead of just writing I was seeing (nearly exactly) the same
>> amount of read I/O as write I/O. The non-spare device was getting
>> almost exclusively read I/O as expected. Why was the spare getting any
>> read I/O at all?
>
> It sounds like it is doing a 'repair' rather than a 'recover'.
> 'repair' happens when you write the word 'repair' to
> /sys/block/mdX/md/sync_action.
>
> In situations like this it is always best to provide lots of detail.
> e.g. kernel logs of the time when things were happening, "mdadm -E" or
> all devices.  The exact data you looked at to make you think there was
> something going wrong (in this case, whatever statistics you found
> that suggested lots of read requests).
>
> Without those specifics it is hard to try to reproduce, and hard to
> guess what was actually happening.
>

Yes it is hard to guess what is happening here; however, should not
the following commit go to -stable?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=56ac36d722d0d27c03599d1245ac0ab59e474e5c

Regards,
Dan
