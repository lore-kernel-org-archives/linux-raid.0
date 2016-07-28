From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 14:08:23 +0100
Message-ID: <354d54b6-31ce-a047-be0c-1e820d5b030e@youngman.org.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
 <CAFx4rwR0+wR_0GXh3Y7j1hZyv0_Gy7b4OD-D2+bfxV9MRp+b3Q@mail.gmail.com>
 <7af0cc98-e395-9446-05eb-a6c0ca20f187@websitemanagers.com.au>
 <CAFx4rwTMySfR27gT6You7f2T28Hq8m5Zxme1p43Fv1vtcpt_-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTMySfR27gT6You7f2T28Hq8m5Zxme1p43Fv1vtcpt_-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/07/16 01:11, Doug Dumitru wrote:
> I don't know about you, but I do have SSDs, even from major vendors,
> that fail.  They usually "just fall off the bus" with no warning.  So
> I dislike skipping redundancy.  RAID turned an emergency into a
> mundane task.  It is really a cost issue.  If you can afford RAID-10
> and extra space, that will work best.  I don't think RAID-50 with this
> few drives makes much sense.
I came across an article about testing SSDs to destruction. First the 
good news - they tended to last much longer than expected. And the bad 
news? They typically contain a self-destruct switch. Once they start 
failing, a power-cycle will (intentionally) kill them dead. ESPECIALLY 
if they're from a major vendor.

So if you don't notice they're dying, or (as in the case of the tester) 
you have power problems that tip them over the edge, your data WILL be 
gone without warning.

Cheers,
Wol
