From: Phil Turmel <philip@turmel.org>
Subject: Re: problem with raid after reboot
Date: Mon, 10 Dec 2012 10:04:53 -0500
Message-ID: <50C5FA15.9000600@turmel.org>
References: <CADzS=aqXh08P+ujEoJPMBxPiZ-PeEdk3x3iRW1ymAvhtpZcDmA@mail.gmail.com> <50C5EA89.40804@turmel.org> <CADzS=aq_83Nr55m+LFywx6LqHdwwkfzfBM+tPv8gcf6ono_j8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aq_83Nr55m+LFywx6LqHdwwkfzfBM+tPv8gcf6ono_j8g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mathieu,

[Top-posting repaired.  Please don't.]

[List address restored.  Please use reply-to-all on kernel.org lists.]

On 12/10/2012 09:14 AM, bobzer wrote:
>> Hi Mathieu,

[trim /]

>> It looks like the superblocks didn't get updated together due to your
>> improper reboot.  (Event counts don't match.)
>>
>> I suggest you stop the array and reassemble with "--force", like so:
>>
>> mdadm --stop /dev/md0
>> mdadm --assemble --force /dev/md0 /dev/sd[bcd]1
>>
>> The "--force" option will instruct mdadm to ignore the event count
>> mismatch.
>>
>> You probably want to investigate why your array wasn't properly stopped
>> during shutdown.

> Hi Phil,
> thanks to help me.
>
> what do you think of the array state ?it' s look strange no ?
>
>    Device Role : Active device 0
>    Array State : A.. ('A' == active, '.' == missing)
>
>    Device Role : Active device 1
>    Array State : AAA ('A' == active, '.' == missing)
>
>    Device Role : Active device 2
>    Array State : AAA ('A' == active, '.' == missing)
>
> do you think it's a problem ?

It's a side-effect of the improper shutdown.  Two devices' superblocks
weren't saved properly, and still show everything OK.  But their event
counts are older than the one device that shows a problem.  So mdadm
sees that one device as most up-to-date, and cannot start the raid5 from
just that one.

Please try the commands I recommended.

Phil
