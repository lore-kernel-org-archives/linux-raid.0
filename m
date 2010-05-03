From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 00/28] md patches destined for -next and the next merge
	window
Date: Mon, 3 May 2010 08:27:04 -0700
Message-ID: <h2re9c3a7c21005030827xad33d108jede23a2036734f4d@mail.gmail.com>
References: <20100415061516.5126.53068.stgit@notabene.brown>
	 <s2se9c3a7c21005021059l5f708347u8d1b936440161b1a@mail.gmail.com>
	 <20100503131116.459bdc7f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100503131116.459bdc7f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 2, 2010 at 8:11 PM, Neil Brown <neilb@suse.de> wrote:
> On Sun, 2 May 2010 10:59:02 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>> A few fixes/enhancements while playing with the takeover code are av=
ailable at:
>>
>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-ne=
il
>
> Thanks - they all make sense.
> I've merged them with my queue and push them to my for-next branch.

Ok, thanks, and this one below on the 'fixes' branch...?

>> I'd like to get "raid6: fix recovery performance regression" in for
>> 2.6.34. =A0I pushed it out to the url below, let me know if you just
>> want me to send it directly.
>>
>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git fixes
>>
>> Dan Williams (1):
>> =A0 =A0 =A0 raid6: fix recovery performance regression
>>
>> =A0crypto/async_tx/async_raid6_recov.c | =A0 21 +++++++++++++-------=
-
>> =A01 files changed, 13 insertions(+), 8 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
