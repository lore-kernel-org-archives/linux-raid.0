From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Mon, 03 Jun 2013 20:00:38 -0400
Message-ID: <51AD2E26.4040504@turmel.org>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com> <51AA83FD.8080500@turmel.org> <CAGXrYFSgoLpKO-UHd_tvOh3gs3Ub2qqOKA48kPEA1Pr=cnrUhA@mail.gmail.com> <51AAA0B9.3050908@turmel.org> <CAGXrYFTyzG-hakGrU9j1=TSmjZHbzs2aRypJX=w8O4viS1+Dfg@mail.gmail.com> <51AB4E5C.5060909@turmel.org> <CAGXrYFSiYMDpeTESv_-aA7QsbV0gYnr1seUHWZuS1bWwABk5Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGXrYFSiYMDpeTESv_-aA7QsbV0gYnr1seUHWZuS1bWwABk5Pg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Finley <debenbain@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/03/2013 07:35 PM, Chris Finley wrote:
> On Sun, Jun 2, 2013 at 6:53 AM, Phil Turmel <philip@turmel.org> wrote:
> [trim /]
>>
>> There are numerous discussions in the archives...  search them for
>> combinations of "scterc", "tler", and "ure".
>>
> It appears this has been a frequent issue over the last year. Thank
> you for the background information, I understand what I was reading.
> 
>>
>> So your device role order is /dev/sd{c,b,d,e}1.
> 
> [trim /]
> 
>> Anyways, the quickest way for you to have a running array is to use
>> "mdadm --assemble --force /dev/md0 /dev/sd{c,b,e}1".  This leaves out
>> the first dropped disk.  Any remaining UREs cannot be corrected while
>> degraded, but the data on the first dropped disk is suspect.
>>
>> Feel free to use an overlay on /dev/md0 itself while making your first
>> attempt to mount and access the data.  If you cannot get critical data,
>> stop and re-assemble with all four devices.
>>
>> Phil
>>
> Thanks, I will do that.
> 
> I am correct in thinking that I should not set scterc to 7 seconds
> initially, since there will not be any parity to correct the read
> errors? Best would be to set the driver time-out to 180 seconds until
> after the array is rebuilt?

Correct.

> I am concerned about read errors during the rebuild. With a failed and
> rebuilding array, will the get drive kicked on an URE? Is it better to
> use something like badblocks or dd_rescue to correct/mark the sectors
> first and then rebuild? Either way, I'm going to lose that data, but
> maybe there are some better tools for extracting data from a bad
> sector?

MD raid will tolerate a burst of up to 20 read errors on a device (in
one hour), and up to 10 per hour after that.

If a drive is booted out, just reassemble and resume your backup
efforts.  Or you can use dd_rescue to avoid it.  Six of one, ...

> After the rebuild is complete, I should set the scterc to 7 seconds
> and add a bitmap based write-intent log?

Yes.  The write-intent log is useful but unrelated to your troubles.
You really need a weekly cron job that'll start a "check" scrub on your
array.  But:

No, don't rebuild onto a 4th drive until after you make a backup of your
critical data.  There's always the chance that the data you really want
isn't on any pending UREs.  Rebuilding is sure to hit those.

> Does anyone learn these things the easy way :)

Apparently not.  (Certainly not me.)  Anyways, the enterprise and
hobbyist use cases are really quite different.  Enterprise users, who
can easily justify premium components, have few problems.  Hobbyists who
are trying to apply the original mean of "raid" (where "i" ==
inexpensive) are prone to problems.

And it isn't entirely the drive manufacturers' fault:  solo duty in a
desktop really needs a different behavior than a member of a raid array.
 However, I *do* fault vendors who have dropped scterc support to push
hobbyists into enterprise products.  I think the market will punish them
in the long term.

> Much appreciated, Chris

You're welcome.

Phil

