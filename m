From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 00/13] Add missing handling of malloc() failure
Date: Thu, 27 Oct 2011 09:39:41 +0200
Message-ID: <4EA90ABD.40003@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com> <20111027154926.4d5e8fef@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111027154926.4d5e8fef@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/11 06:49, NeilBrown wrote:
>> Hi,
>> > 
>> > I cam across a couple of these last week while I was chasing the
>> > assemble problem of IMSM raids, so I started going through the code to
>> > fix up some more of these.
>> > 
>> > This is just low hanging fruit, and there is more to be done, but at
>> > least it's a few fixes.
> Hi,
> 
>  I'm not at all sure this sort of thing is worth it.
>  There is no guarantee that the memory is actually there when malloc returns
>  non-NULL.  You might only get a page mapped when you access the memory, and
>  equally the failure could happen at that time.
> 
>  If there is something genuinely useful that can be done when malloc fails,
>  the it might make sense, but just printing a message an exiting seems
>  pointless.
> 
>  If we were to go that route, I would probably want to use a #define to
>  replace everything with a wrapper (xmalloc??) that printed a message and
>  failed.
> 
>  Do you have a strong reason to add these checks?

Hi Neil,

There are a couple of reasons for this. You are right that things could
happen during touching the page at first, but in general malloc() is
supposed to fail if the system is unable to provide the pages.

The main reason why I think this is worth doing is for support reasons.
While in most cases these cases will never fail, I much prefer a user to
find out of memory messages in their log files or on the terminal, than
having them report a segfault which we need to investigate the reason
of. Having better error messages in place should reduce the cost of this.

Second, there are cases where malloc() fails where I think we really
need to try and unwind, rather than possibly leaving raid or metadata in
an inconsistent state. Passing errors back should help with this.

Third I think it is good practice not to leave error codes unchecked. In
the cases where I let the code exit() on error, I was pretty much
following the precedence in the same function I added the check to. I
don't think it is ideal, but I do think it is a starting point.

Some of the bits in my patchset could definitely handle the errors
better, but I still don't know all the code that well, so I think it is
a start. Getting error handling consistent across the board is a big
project and I don't think it is realistic to do it all in one go.

Cheers,
Jes
