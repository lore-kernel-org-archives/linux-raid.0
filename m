From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [LSF/MM TOPIC] (again) THP for file systems
Date: Thu, 14 Feb 2019 17:10:25 +0000
Message-ID: <5C65A101.4010909@youngman.org.uk>
References: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
 <20190213235959.GX12668@bombadil.infradead.org>
 <843818E0-C7E8-451E-A5B1-DAF0F120BD5A@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <843818E0-C7E8-451E-A5B1-DAF0F120BD5A@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Matthew Wilcox <willy@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-raid.ids

On 14/02/19 01:59, Song Liu wrote:
>> I believe the direction is clear.  It needs people to do the work.
>> > We're critically short of reviewers.  I got precious little review of
>> > the original XArray work, which made Andrew nervous and delayed its
>> > integration.  Now I'm getting little review of the followup patches
>> > to lay the groundwork for filesystems to support larger page sizes.
>> > I have very little patience for this situation.

> I don't feel I am a qualified reviewer for MM patches, yet. But I will 
> try my best to catch up. 

Then just dive in!

Ask questions - "what does this do?", "please explain this, I don't
understand", "I'm new here, please teach me".

Okay, some people are too busy to help much, but I've found looking
after the raid wiki that people are happy to help, *especially* if they
know that their time is going to be rewarded. If I ask for help it
usually results in an update to the wiki.

If they know you are reading through the patch asking them to explain it
helps two ways - you are another set of eyes to spot something wrong,
and your questions will make them look at their code in a new light.
Even if you don't understand what you're looking at, you can still spot
stuff that looks weird, and if you ask them to explain then it will mean
that code gets an extra check. Anything that slips through that is
probably fine.

Cheers,
Wol
