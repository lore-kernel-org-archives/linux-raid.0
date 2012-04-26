From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Thu, 26 Apr 2012 17:36:10 +0200
Message-ID: <4F996B6A.4070705@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com> <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com> <4F99674B.7070900@redhat.com> <4F996800.2050603@redhat.com> <4F9968F0.30805@redhat.com> <4F996A94.3060509@twiddle.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F996A94.3060509@twiddle.net>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>
Cc: Doug Ledford <dledford@redhat.com>, neilb@suse.de, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/26/12 17:32, Richard Henderson wrote:
> On 04/26/12 08:25, Jes Sorensen wrote:
>> Just checking mdadm.h and bswap32() is defined like this:
>>
>> #define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
>>                      ((x) & 0xff000000U) >> 24 | \
>>                      ((x) & 0x0000ff00U) << 8  | \
>>                      ((x) & 0x00ff0000U) >> 8)
>>
>> so I am not 100% sure just swapping to an s32 in the struct will work on
>> big endian systems? Will the 0x000000ffU not force the conversion back
>> to unsigned or what happens in this case?
> 
> This is actually semi-complicated.  c89 or c99 rules?  X already of a
> type larger than unsigned int?

This is what I was afraid of :)

> But if X is signed int, this entire expression will always be unsigned.
> 
> You're certainly better off with a cast as we discussed on irc.

In this particular case X would be a signed int, so we would end up with
unsigned and still need the cast.

I will opt for the cast in this case - thanks a lot for the clarification.

Cheers,
Jes
