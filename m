From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 09 Feb 2009 16:47:33 +0000
Message-ID: <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The typical use case for me is this: I will run the array (/dev/md11) in
> degraded mode (without /dev/nbd0) for a week or so.
> At some point, I will try to synchronize the underlying devices.

Sounds like rsync is more suited to your application.
Why are you using RAID?

Iain


