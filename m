From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 11:25:23 -0600
Message-ID: <cccedfc60902090925s78769febl678445fdd56b7539@mail.gmail.com>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
	 <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 9, 2009 at 10:47 AM, Iain Rauch
<groups@email.iain.rauch.co.uk> wrote:
>> The typical use case for me is this: I will run the array (/dev/md11) in
>> degraded mode (without /dev/nbd0) for a week or so.
>> At some point, I will try to synchronize the underlying devices.
>
> Sounds like rsync is more suited to your application.
> Why are you using RAID?

If I were transferring files then rsync would be fine. Files have
mutable state (applications may be writing to them at the time of
transfer, etc...) and a whole host of other issues.

> Why are you using RAID?

I want a *mirror* of the block device.


-- 
Jon
