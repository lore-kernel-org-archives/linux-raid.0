From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Rebuild events while scrubbing - problems or just informational?
Date: Wed, 11 Dec 2013 06:34:57 -0800
Message-ID: <CAK2H+ee8-emZJ1cHK-74KGLJYQwxyQZ-u-KJYGcN0vXucr8_aA@mail.gmail.com>
References: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>
	<20131210085225.GA441@cthulhu.home.robinhill.me.uk>
	<52A7476A.9060307@gmail.com>
	<20131211123826.0942ea22@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131211123826.0942ea22@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the pointer Neil. Glad to know there isn't a problem here.

Cheers,
Mark

On Tue, Dec 10, 2013 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 10 Dec 2013 17:55:06 +0100 Can Jeuleers <can.jeuleers@gmail.com>
> wrote:
>
>> On 12/10/2013 09:52 AM, Robin Hill wrote:
>> >> Dec  8 14:30:01 c2RAID6 mdadm[1838]: RebuildStarted event detected on
>> >> md device /dev/md/3
>> >> Dec  8 15:03:21 c2RAID6 mdadm[1838]: Rebuild26 event detected on md
>> >> device /dev/md/3
>> >> Dec  8 15:36:41 c2RAID6 mdadm[1838]: Rebuild49 event detected on md
>> >> device /dev/md/3
>> >> Dec  8 16:10:01 c2RAID6 mdadm[1838]: Rebuild70 event detected on md
>> >> device /dev/md/3
>> >> Dec  8 16:43:21 c2RAID6 mdadm[1838]: Rebuild87 event detected on md
>> >> device /dev/md/3
>> >>
>> >
>> > They're perfectly normal if you're doing a repair - I don't think they
>> > should be there for a check though. It's just mdadm in monitor mode
>> > reporting the progress (the numbers are the percentage completed) to
>> > syslog.  According to the manual the default reporting interval is 20
>> > percent, but I think it actually triggers on a completed stripe (or
>> > block of stripes) so the numbers aren't exactly on the interval.
>>
>> I see them as well during checks. Although I can't find documentation
>> stating so I regard them as normal.
>> --
>
> % man mdadm
>
> Search for "RebuildStarted"
>
>            RebuildStarted
>                   An  md array started reconstruction. (syslog priority: Warn-
>                   ing)
>
>
>            RebuildNN
>                   Where NN is a two-digit number (ie. 05, 48). This  indicates
>                   that  rebuild has passed that many percent of the total. The
>                   events are generated with fixed increment since 0. Increment
>                   size  may be specified with a commandline option (default is
>                   20). (syslog priority: Warning)
>
>
>
> This is in a section which starts
>
> MONITOR MODE
>        Usage: mdadm --monitor options... devices...
>
>
>        This usage causes mdadm to periodically poll a number of md arrays  and
>        to report on any events noticed.  mdadm will never exit once it decides
>        that there are arrays to be checked, so it should normally  be  run  in
>        the background.
>
>
> I guess that doesn't explicitly say it is normal, but that is the intent :-)
>
> They should be generated from recovery, resync, reshape, check, repair and
> anything else that might be added which processes the whole array like that.
> I guess "Rebuild" isn't a very generic word.. but
>    "StuffStarted"
>    "Stuff20"
>    "StuffFinished"
> probably wouldn't go down well either.
>
>
> Thanks,
> NeilBrown
>
