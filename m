From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Wed, 16 Oct 2013 22:10:54 +0200
Message-ID: <CAC9WiBiwSHTC6o2sXwjqyy78B07VCgkdJG5PpHGyYu8bNV4JvA@mail.gmail.com>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914064305.0baadc69@notabene.brown>
	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
	<20130914203800.385466b2@notabene.brown>
	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>
	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
	<5234CA6A.3070305@arcor.de>
	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
	<52373A19.7000105@arcor.de>
	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>
	<523C8EF9.60809@arcor.de>
	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com>
	<CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
	<52409E62.3090105@arcor.de>
	<CAC9WiBigzwNFV2FSU+tWS969fh+6G6ikQcrDqDyW0CbiaOuLkQ@mail.gmail.com>
	<CAC9WiBje39ij9RLEqe8aha3FGn_LirxzQezXx-s5+J-HqUpwug@mail.gmail.com>
	<524C6711.3090805@arcor.de>
	<20131016155711.715678e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131016155711.715678e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Wed, Oct 16, 2013 at 6:57 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 02 Oct 2013 20:33:53 +0200 Martin Wilck <mwilck@arcor.de> wrote:
>
>> On 09/27/2013 05:47 PM, Francis Moreau wrote:
>>
>> > I finally found my issue: mdmon --takeover service wasn't started
>> > anymore (probably I messed it up earlier). Therefore mdmon started by
>> > initrd was used and wasn't working properly.
>>
>> Thanks a lot for finding this out, glad your system is working again.
>> And sorry for having lost you and talking about the BIOS; I was thinking
>> you were still working on fake BIOS hardware.
>>
>> > If you still want me to test something, please tell me.
>> >
>> > OTHO, it would be easier if you setup a git tree somewhere with your
>> > patches that you want me to test. BTW I'm not subscribed to linux-raid
>> > mailing list.
>>
>> I'll wait for Neil to come back and comment on my patches. It doesn't
>> make sense for me right now to create my own repository.
>
> Hi,
>  I'm back from leave now :-)
>  Your patches look good - thanks a lots.
>  I think I have applied them all (though the numbering was a bit odd and I
>  might have missed something).
>
>  I've lost track ... are there any outstanding issues here, or are we "done" ?
>

I think there's still one open issue when sequence numbers don't match during
incremental assembly.

Martin started addressing this in another new thread whose subject is
"RFC: incremental container assembly when sequence numbers don't
match"

Thanks
-- 
Francis
