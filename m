From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid10 layout for 2xSSDs
Date: Tue, 17 Nov 2009 05:46:25 +0100
Message-ID: <87pr7hlpwe.fsf@frosties.localdomain>
References: <1258381745.31633.35.camel@localhost>
	<7bc80d500911160808o4ca4d335gdeeb50fff61b2149@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500911160808o4ca4d335gdeeb50fff61b2149@mail.gmail.com>
	(Christopher Chen's message of "Mon, 16 Nov 2009 08:08:49 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Chen <muffaleta@gmail.com>
Cc: Kasper Sandberg <postmaster@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Chen <muffaleta@gmail.com> writes:

> On Mon, Nov 16, 2009 at 6:29 AM, Kasper Sandberg <postmaster@metanurb.dk> wrote:
>> Hello.
>>
>> I've been wanting to create a raid10 array of two SSDs, and I am
>> currently considering the layout.
>>
>> As i understand it, near layout is similar to raid1, and will only
>> provide a speedup if theres 2 reads at the same time, not a single
>> sequential read.
>>
>> so the choice is really between far and offset. As i see it, the
>> difference is, that offset tries to reduce the seeking for writing
>> compared to far, but that if you dont consider the seeking penalty,
>> average sequential write speed across the entire array should be roughly
>> the same with offset and far, with offset perhaps being a tad more
>> "stable", is this a correct assumption? if it is, that would mean offset
>> provides a higher "garantueed" speed than far, but with a lower maximum
>> speed.
>
> Do you plan to have more than two devices in the array? Raid 10 isn't
> magic. If you don't have more than do devices, I suppose your seek
> time might be half for reads (and higher for writes), but you won't be
> able to do any striping.
>
> I'm a bit confused as to the number of people popping in recently
> wanting to run raid 10 on two disk "arrays".
>
> cc

I think you are missing the fact that linux has a special raid10
module. This is not just a raid0 over raid1 (or raid1 over raid0).
The raid10 module is much more flexible and allows to have X copies of
the data on Y disks (for any X <= Y) in different layouts.

The layouts are like this (for 2 copies on 2 disks):

near (same as raid1):

Disk A: 0 1 2 3 4 5 6 7 8 9
Disk B: 0 1 2 3 4 5 6 7 8 9 

offset:

Disk A: 0 1 2 3 4 5 6 7 8 9
Disk B: 1 0 3 2 5 4 7 6 9 8

far:

Disk A: 0 2 4 6 8 1 3 5 7 9
Disk B: 1 3 5 7 9 0 2 4 6 8

In the case of offset and far copies you can see that the data is
striped like in raid0 and the raid10 module will read data from
multiple drives in parallel even with a single stream.

In raid10 far mode the read will also (afaik, not 100% sure) always
come from the first half of the disk. With rotational disks that is
usualy the faster part. So you not only get double the read speed from
striping but also more speed from the disks itself. For example my
disk does 80MB/s at the start, 60MB/s in the middle and 40MB/s at the
end. Reads will only use the 80-60MB/s range now. Jupey.

MfG
        Goswin
