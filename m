From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Thu, 26 Apr 2012 17:21:36 +0200
Message-ID: <4F996800.2050603@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com> <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com> <4F99674B.7070900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F99674B.7070900@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: neilb@suse.de, joe.lawrence@stratus.com, linux-raid@vger.kernel.org, Richard Henderson <rth@twiddle.net>
List-Id: linux-raid.ids

On 04/26/12 17:18, Doug Ledford wrote:
> On 04/26/2012 11:12 AM, Jes.Sorensen@redhat.com wrote:
>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> > 
>> > fbdef49811c9e2b54e2064d9af68cfffa77c6e77 incorrectly tried to fix sign
>> > extension of the bitmap offset. However mdinfo->bitmap_offset is a u32
>> > and needs to be converted to a 32 bit signed integer before the sign
>> > extension.
>> > 
>> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> I was scratching my head over this patch, saying to myself "But won't
> that cause us to truncate large values of bitmap_offset?"  And it will,
> but I see your point now, that's *exactly* the problem if we don't do
> the sign conversion before the extension, the actual bitmap_offset
> should really be signed in order to support negative offsets, but since
> it isn't, when we save a negative offset into bitmap_offset it appears
> as a really large positive offset, and then when we sign extend to long,
> it keeps the large size positive offset instead of picking up the
> negative offset.  Gotcha.  So, I see why this works, but do you think it
> should be fixed this way, or by converting bitmap_offset to type int32
> instead of uint32?

Heh, I have to admit I cheated too and asked Richard Henderson for help
as I couldn't figure out why the sign conversion failed. Otherwise I
would probably still have been scratching my head over it :)

I noticed other parts of the code already handled it this way, so my fix
is consistent with that, but we could do both. Neil?

Cheers,
Jes


