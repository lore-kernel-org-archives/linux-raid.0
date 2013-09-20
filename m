From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Thu, 19 Sep 2013 22:29:11 -0700
Message-ID: <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523A7DB9.9070600@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for replying, Stan.

I am not actually sure what are the bare, required facts, so I had
just tried to include the information that I could obtain from mdadm.

At this point, I have been running GNU ddrescue (e.g., ddrescue
--cluster-size=65536 --no-split --force /dev/source /dev/destination
/.../log.txt) to transfer two of the complete drives to two of the
larger four drives that I have.  No errors have shown up whatsoever so
far, which jives with the SMART results.  In a couple of more days, I
should have all four copied over, then I could try risk writing to the
four larger drives.

I know that the set of 4 drives had been set aside for quite a while.
They were completely out of space.  I booted the recovery disk for a
couple of reasons.  One was that when I booted normally, they had
shown up with one marked as failed.  However, there seems to be no
actual error, so I can only guess that prior to having set them aside
some time ago, I had failed one on purpose in order to install a
larger drive and begin a migration, but got interrupted by life's
events.  The other reason was that I had (mistakenly) thought it would
be a good idea to use the recovery disk as an environment from which
to migrate the data to larger drives.  I was also adding hardware to
support port multiplication (don't have 8 sata ports onboard) and
thought it would be helpful to be running a relatively bare-bones
setup.

Dave


On 18 September 2013 21:29, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 9/18/2013 10:20 PM, Dave Gomboc wrote:
> ...
>> Having received no response to date, I am wondering if this perhaps
>> isn't the right forum for asking for advice regarding my problem.  If
>> it is not, could someone please suggest where I should be asking
>> instead?
>
> This is the right place.  I suspect your somewhat convoluted report had
> folks scratching their heads, all hoping someone else would pick this
> one up.  Could you condense it into the bare required facts?
>
> Also, I didn't see a statement as to why you booted the recovery disk to
> begin with.  That fact alone suggests you already had some problem.
> What was it?
>
> --
> Stan
>
