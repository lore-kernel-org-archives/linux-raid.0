From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: question about bitmaps and dirty percentile
Date: Fri, 31 Jul 2009 14:17:53 -0400
Message-ID: <4A733551.5010408@steeleye.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com> <cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> On Thu, Jul 30, 2009 at 1:25 PM, Jon
> Nelson<jnelson-linux-raid@jamponi.net> wrote:
>> Then things got weird.
>>
>> I saw this, which just *can't* be right:
>>
>> md12 : active raid1 nbd0[2](W) sde[0]
>>      72612988 blocks super 1.1 [3/1] [U__]
>>      [======================================>]  recovery =192.7%
>> (69979200/36306494) finish=13228593199978.6min speed=11620K/sec
>>      bitmap: 139/139 pages [556KB], 256KB chunk
>>
>> and of course the percentile kept growing, and the finish minutes are crazy.
> 
> Weirdness: it ready 199 (or so) and then completed:
> 
> md12 : active raid1 nbd0[2](W) sde[0]
>       72612988 blocks super 1.1 [3/2] [UU_]
>       bitmap: 139/139 pages [556KB], 256KB chunk
> 
> I --fail, --remove the device, and then --re-add it.
> 
> The recovery *starts over*, as if nothing had happened over the last hour or so.
> The event counter are very close between /dev/nbd0 (the device here)
> and /dev/sde (the core device), within a dozen or so, but the "dirty
> percentile" on /dev/nbd0 is big - 18.8%, and unchanging between runs.
> It's like the bitmap isn't getting updated, or getting updated
> incompletely, or something.
> 
> Does the bitmap only get updated when *all* devices have sync'd???
> I'll let you know in about 2 hours.

The bitmap never gets cleared unless all disks in the array are in sync.

--
Paul
