From: Phil Turmel <philip@turmel.org>
Subject: Re: How to prefer some devices over others in raid
Date: Wed, 01 Jan 2014 15:21:50 -0500
Message-ID: <52C478DE.2060504@turmel.org>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com> <52C2E00B.90406@hardwarefreak.com> <CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com> <52C44708.3030307@hardwarefreak.com> <CAL1oBhovXZhnKMqzoYt=7N5ZHeyX76LK+1LNYMRmcQGGqs7W3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL1oBhovXZhnKMqzoYt=7N5ZHeyX76LK+1LNYMRmcQGGqs7W3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas M <tomas@slax.org>, stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/01/2014 01:00 PM, Tomas M wrote:
>> Your initial post suggested you knew which drive was flaky.  Now you
>> indicate you don't know which, if any, is flaky.  This suggests you have
>> no idea why your array is slow.
> 
> Well, I always have an indication which drive is flaky, based on dmesg
> output (e.g. hard resetting ATA3 link, etc). However, sometimes it
> reports that more than one drive has problems, and I can't be 100%
> sure which of the flaky drives is the "more flaky" one :) and it is
> too late to replace any of them, since there is high chance that the
> other one dies as well during resync (which happened to me few times
> already). From my point of view it is better for me to keep the array
> in sync as long as I can, and copy the data somewhere as fast as I
> can.

If you've experienced drive drops during resync a "few times already",
and you don't say that such drives were obviously dead, it makes me
suspicious that you are using non-enterprise drives.

Using non-enterprise drive in any raid array can expose you to false
failures from the timeout mismatch problem.  If you care to share the
output of "smartctl -x" for all of your drives, and "for x in
/sys/block/*/device/timeout ; do echo $x $(< $x) ; done", we can
immediately figure that out for you.

If you want to understand the issue, search this list's archives for
various combinations of "scterc", "URE", "timeout mismatch".  You should
also see if your distro has a cron job that performs a "check" scrub on
your arrays for you.

HTH,

Phil
