From: Michael Demmer <Michael.Demmer@riverbed.com>
Subject: Re: bug in bio_map_user_iov
Date: Thu, 18 Nov 2010 13:08:49 -0800
Message-ID: <4845A84C-AE4A-41FF-9147-719D414F27D8@riverbed.com>
References: <4A89C515-6A74-4C0B-9A81-8FAB6C36AFF0@riverbed.com>
 <20101118110252.498cc1ea@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118110252.498cc1ea@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Hello all,
>> 
>> I've been doing some work with a Linux kernel module that enables zero-copy I/O to block devices using a custom user/kernel interface. In porting this from an older Linux kernel to a more modern release, I ran into an issue when interacting with MD devices that I traced back to what I believe to be a problem in bio_map_user_iov.
>> 
>> The problem and fix are described in the first attached patch. The second is a simple test module and user program which triggers the bug and validates the fix.
>> 
>> Thanks,
>> -m
>> 
>> ps. This is my first attempt at pushing a patch upstream so please forgive any newbie mistakes.
>> 
> 
> I think the real issue here is that bio_map_user is an interface that was
> only intended to be used by bottom level devices like SCSI drivers etc.
> It is a function that a device driver can use if it knows that it makes sense
> to use it.
> 
> You are trying to use it as a generic interface that works for all block
> devices, and it wasn't intended for that.
> 
> So while it is reasonably simple to 'fix' bio_map_user_iov, it is not
> possible to 'fix' bio_map_kern_iov in the same way, because it doesn't have
> access to the bdev at all.
> 
> 
> So the question we should be asking is: are you really using the right
> interface for the job?  Is bio_map_user something that you really should be
> using?
> And to answer that, we would need to know what you are trying to do.
> 
> And why isn't O_DIRECT a suitable zero-copy interface for I/O to block
> devices?

Thanks -- I understand your concerns, but unfortunately I can't really go into more detail about our use case since it's something we use internally. Given which, I understand your potential reluctance to take the patch.

Best,
-m



