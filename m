From: David Rees <drees76@gmail.com>
Subject: Re: RAID1 write-behind not working?
Date: Thu, 26 Mar 2009 10:28:58 -0700
Message-ID: <72dbd3150903261028idacb20esc9e56854379d76bb@mail.gmail.com>
References: <72dbd3150903251739q21de8a2ew835860f9e3b11d14@mail.gmail.com>
	 <49CB7CB2.1020105@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CB7CB2.1020105@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(re-adding linux-raid to Cc)

On Thu, Mar 26, 2009 at 6:01 AM, Bill Davidsen <davidsen@tmr.com> wrote=
:
> David Rees wrote:
>> My only guess is that by specifying fdatasync on the dd command, tha=
t
>> forces the data to be written out to all members of the array. =A0No=
t
>> quite intuitive if that is by design - because otherwise, when are y=
ou
>> able to take advantage of the write-behind feature.
>>
>> The system I was testing on was running off a Fedora 10 live CD, so
>> it's not the most recent software, but it's not that old, either:
>> (kernel 2.6.27.5-117.fc10, mdadm 2.6.7.1).
>>
>> Can anyone confirm that write-behind is working for them, and a quic=
k
>> test to show that it's working?
>
> I agree that it's not obvious that fdatasync would work that way, but
> thinking about it, that's correct behavior. You would use fdatasync w=
hen you
> want to be really sure the data is on the device. =A0This may be hard=
 to
> measure, but perhaps using "iostat" with a 1 sec sample would at leas=
t let
> you see the i/o rates and convince yourself that it is working as exp=
ected.

Yeah, it does kind of make sense in theory, but it seems that it would
be useful to relax it as it seems like it would largely negate most of
the benefits of write-behind, no?

After all, in most cases, data doesn't start getting written to disk
until you really want it there, either in userpspace using fsync or
because the kernel has decided it's time to start flushing data to
disk as it's reached it's dirty limits.

In this case, all I really care is that the data has been written to
the non-write-mostly disks and that the write-mostly disks can lag by
the number of IOs I've specified.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
