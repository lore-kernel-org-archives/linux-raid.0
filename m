From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 14:56:21 -0600
Message-ID: <cccedfc60902091256y5a280b0drb468c2757ffdb980@mail.gmail.com>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
	 <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
	 <20090209165940.GA805@esri.com>
	 <cccedfc60902090949sec3336u661cea5fbb96e246@mail.gmail.com>
	 <4990843B.7010708@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4990843B.7010708@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 9, 2009 at 1:30 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Jon Nelson wrote:
>>
>> I don't think so. This is how I *remove* the nbd device:
>>
>> mdadm /dev/md11 --fail /dev/nbd0
>> sleep 3
>> mdadm /dev/md11 --remove /dev/nbd0
>>
>> and then finally nbd-client -d /dev/nbd0
>>
>> If necessary, I can try to simulate the problem by using a local
>> logical volume or some such.
>>
>
> I would try this with just the first step. I looked at the code briefly, and
> I think the write intent bitmap will not get built for a removed device but
> will for failed. In any case it's certainly something you can easily try.

Nope. :-(  --remove is necessary.

turnip:~ # mdadm --fail /dev/md11 /dev/nbd0
mdadm: set /dev/nbd0 faulty in /dev/md11
turnip:~ # mdadm --re-add /dev/md11 /dev/nbd0
mdadm: Cannot open /dev/nbd0: Device or resource busy
turnip:~ # mdadm --add /dev/md11 /dev/nbd0
mdadm: Cannot open /dev/nbd0: Device or resource busy
turnip:~ #


-- 
Jon
