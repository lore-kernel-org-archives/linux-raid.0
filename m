From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Sat, 1 Nov 2014 11:06:16 +0530
Message-ID: <CAK-d5dbNS4Y1uiHuUh=fL0e9WScvOKNg5Frves439JmZNaL-+A@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <CAJvUf-BktH_E6jb5d94VuMVEBf_Be4i_8u_kBYU52Df1cu0gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BktH_E6jb5d94VuMVEBf_Be4i_8u_kBYU52Df1cu0gmg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 October 2014 19:53, Matt Garman <matthew.garman@gmail.com> wrote:
> In a later post, you said you had a 4-to-1 scheme, but it wasn't clear to me
> if that was 1 drive worth of data, and 4 drives worth of checksum/backup, or
> the other way around.

I was wondering if anybody would catch that slip. I meant 4 data to 1
parity seems about the right mix to me so far based on the my read and
feel of probability of drive failure.

>
> In your proposed scheme, I assume you want your actual data drives to be
> spinning all the time?  Otherwise, when you go to read data (play
> music/videos), you have the multi-second spinup delay... or is that OK with
> you?

Well, actually in my experience with 6-8, 2-4TB drives there is a lot
of music/video content that I dont' end up playing that often. Those
drives can easily be spun down (maybe for days on end and at least all
night) and a small initial (one time) delay before playing a file who
drive hasn't been accessed easily seems like a good trade off ( both
for power and drive life )

>
> Some other considerations: modern 5400 RPM drives generally consume less
> than five watts in idle state[1].  Actual AC draw will be higher due to
> power supply inefficiency, so we'll err on the conservative side and say
> each drive requires 10 AC watts of power.  My electrical rates in Chicago
> are about average for the USA (11 or 12 cents/kWH), and conveniently it
> roughly works out such that one always-on watt costs about $1/year.  So,
> each always-running hard drive will cost about $10/year to run, less with a
> more efficient power supply.  I know electricity is substantially more
> expensive in many parts of the world; or maybe you're running off-the-grid
> (e.g. solar) and have a very small power budget?

Besides the cost, there is an environmental aspect. If something has
superior efficiency and increases life of the product isn't it a good
thing wherever we live on the planet. BTW great calculation but I
moved back (to India) from San Francisco some time ago :) and the
electricity cost is quite high (and availability of supply is not 100%
yet).  I'd like to maximize my backups and spinning disks that are not
being used for hours on end sounds bad.

Just to add, internet is metered per GB in many parts (and in mine
sadly :( for high speed access (meaning 4-8 MBps) so I have to store
content locally (before cloud suggestions are thrown around)

>
> On Wed, Oct 29, 2014 at 2:15 AM, Anshuman Aggarwal


> <anshuman.aggarwal@gmail.com> wrote:
>>
>> - SnapRAID (http://snapraid.sourceforge.net/) which is a snapshot
>> based scheme (Its advantages are that its in user space and has cross
>> platform support but has the huge disadvantage of every checksum being
>> done from scratch slowing the system, causing immense wear and tear on
>> every snapshot and also losing any information updates upto the
>> snapshot point etc)
>
>
> Last time I looked at SnapRAID, it seemed like yours was its target use
> case.  The "huge disadvantage of every checksum being done from scratch"
> sounds like a SnapRAID feature enhancement that might be
> simpler/easier/faster-to-get done than a major enhancement to the Linux
> kernel (just speculating though).

SnapRAID can't be enhanced without involving the kernel because the
delta checksum will require knowing which blocks were written to and
only a  kernel level driver can know that. This is a hard reality, no
way around it and that was my reason to propose this.


>
> But, on the other hand, by your use case description, writes are very
> infrequent, and you're willing to buffer checksum updates for quite a
> while... so what if you had a *monthly* cron job to do parity syncs?
> Schedule it for a time when the system is unlikely to be used to offset the
> increased load.  That's only 12 "hard" tasks for the drive per year.  I'm
> not an expert, but that doesn't "feel" like a lot of wear and tear.

Well, again, between infrequent updates down to weekly or monthly
crons sounds like a bad compromise either way when a better
incremental update could store the checksum in a buffer and write them
out eventually (2-3 times a day). Almost always the buffer will get
written out giving us an updated parity with little to none "extra"
wear and tear.

>
> On the issue of wear and tear, I've mostly given up trying to understand
> what's best for my drives.  One school of thought says many spinup-spindown
> cycles are actually harder on the drive than running 24/7.  But maybe
> consumer drives actually aren't designed for 24/7 operation, so they're
> better off being cycled up and down.  Or consumer drives can't handle the
> vibrations of being in a case with other 24/7 drives.  But failure
> to"exercise" the entire drive regularly enough might result in a situation
> where an error has developed but you don't know until it's too late or your
> warranty period has expired.

You are right about consumer drives where spin downs are good ...with
a time of an hour or so should reduce unnecessary spin up/downs. Once
spun down, most may stay that way for days which is better for all of
us (energy, wastage of drives etc). Spin down technology is
progressing faster than block failure (also because block density is
going up causing media failure and not the head failure to be the
primary cause of drive outage)

The drive can be tested periodically (by non destructive bad blocks
etc) as a pure testing exercise to find errors being developed. There
is no need to needlessly stress the drives out by reading/writing to
all parts continuously. Also RAID speeds are often no longer required
due to the higher R/W coming from the drives.


Thanks for reading and writing such a thorough reply.

Neil, would you be willing to assist/guide in helping design or with
the best approach to the same? I would like to avoid the obvious
pitfalls that any new kernel block level device writer is bound to
face.

Regards,
Anshuman

>
>
> [1] http://www.silentpcreview.com/article29-page2.html
>
>
