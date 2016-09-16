From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: replace hard coded string length
Date: Fri, 16 Sep 2016 08:38:34 -0400
Message-ID: <wrfjlgysqat1.fsf@redhat.com>
References: <1473898407-3049094-1-git-send-email-songliubraving@fb.com>
        <wrfjr38lxhp9.fsf@redhat.com> <5328253.xG1N6xNRzL@natasha>
        <4115566d-9994-b90a-12cb-83e54c01baba@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4115566d-9994-b90a-12cb-83e54c01baba@websitemanagers.com.au>
        (Adam Goryachev's message of "Fri, 16 Sep 2016 09:34:32 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Thomas Fjellstrom <thomas@fjellstrom.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam Goryachev <mailinglists@websitemanagers.com.au> writes:
> On 16/09/16 04:10, Thomas Fjellstrom wrote:
>> On Thursday, September 15, 2016 12:15:30 PM MDT Jes Sorensen wrote:
>>> I was about to apply this, but this is actually wrong. You need to use
>>> the size of the destination, not of the source as the limit.
>>>
>>> Sorry for the hassle.
>> I'm not aware of the full details, but either they are the same size, or they
>> aren't, and you need to use the minimum size of both to avoid any kind of
>> overflow (source or dest, read and write). I presume the destination is
>> smaller?
> I'm not a programmer, but I think the size of the source is
> irrelevant. If the source is 10 bytes, you can safely copy that to a
> destination of 30 bytes. The only problem is if the source content is
> bigger than the destination. Hence, you should copy only based on the
> destination size.
>
> I'm not sure, but it may be a good idea to confirm that all of the
> source content has been copied, or else there may be unexpected
> results when operating on a truncated value.  I'm sure someone else
> who is an actual programmer can jump in and advise...

Technically you are correct. However if we start adding such checks,
there's a full time job running through the code fixing up cases like
these. This for cases where we know it won't go wrong. It would also be
a large amount of patch churn for no gain.

Cheers,
Jes
