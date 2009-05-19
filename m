From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Enhancements and clean to linear RAID
Date: Tue, 19 May 2009 21:38:29 +1000
Message-ID: <18962.39477.173613.395401@notabene.brown>
References: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
	<9a138833b29b54e5d6c1eaa188f27399.squirrel@neil.brown.name>
	<37d33d830905190031u5172af46kccb720343e359d99@mail.gmail.com>
	<37d33d830905190346g4147a114o5f4a53bf64c1ebac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 19, sandeepksinha@gmail.com wrote:
> Hi Neil,
> 
> I have made all the required changes and have tested the changes.
> It works fine.
> 
> Thanks for enlightening me, the changes really optimized the code further.
> 
> The patches will be followed by this mail.

Thanks.
I have applied them all (with very minor cleanups) and pushed them to
my for-next tree.
They can be viewed here:
    http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/for-next

I have taken the liberty of rewriting the introductory comments on the
patches a little.  I hope you don't mind.

One important part of the patches that was missing was a
"signed-off-by" line.
Please read section 12 of Documentation/SubmittingPatches
and then if you agree that the you an certify the Developer's
Certificate of Origin on these patches, please write explicitly that I
should add your Signed-off-by line to these patches.

I have no doubt that the patches are suitably original, but the
process requires that you explicitly tell me so.

Thanks,
NeilBrown
