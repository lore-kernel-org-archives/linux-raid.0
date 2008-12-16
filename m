From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid1 recovery: reads and writes
Date: Mon, 15 Dec 2008 20:40:24 -0600
Message-ID: <cccedfc60812151840g8febe5ayfda29ae609bca9df@mail.gmail.com>
References: <cccedfc60812150545s7159f0a2x2fa7f36ecf8d9c60@mail.gmail.com>
	 <18758.51053.866819.442495@notabene.brown>
	 <e9c3a7c20812151654u5d644ccbv2c925a2fe2bc1c7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20812151654u5d644ccbv2c925a2fe2bc1c7e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 6:54 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Dec 15, 2008 at 2:09 PM, Neil Brown <neilb@suse.de> wrote:
>> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>>> I have a software raid1 which underwent a recovery recently.
>>> While it was recovering, I could not understand why I was seeing an
>>> equal amount of *read* I/O as write I/O to the device the raid1 was
>>> recovering to. That's to say, the raid1 was rebuilding on to a spare
>>> but instead of just writing I was seeing (nearly exactly) the same
>>> amount of read I/O as write I/O. The non-spare device was getting
>>> almost exclusively read I/O as expected. Why was the spare getting any
>>> read I/O at all?

..

> Yes it is hard to guess what is happening here; however, should not
> the following commit go to -stable?
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=56ac36d722d0d27c03599d1245ac0ab59e474e5c

Is it possible this commit is (partially) responsible for what I was
seeing? Under what conditions would it trigger?

For me, it was a thoroughly unexpected recovery - I had expected to
--re-add the device and have it resync up very quickly - this normally
takes a few seconds, but instead for some reason it went into a full
recovery. I was stracing the nbd-server process responsible for the
block device and it was definitely getting read and write requests in
equal measure. However, later when I actually did rebuild the array
the recovery was (almost) 100% write.

-- 
Jon
