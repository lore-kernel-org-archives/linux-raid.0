From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Thu, 8 May 2008 16:11:53 -0400
Message-ID: <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
	 <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18466.39418.578722.92979@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Thu, May 8, 2008 at 2:13 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 6, snitzer@gmail.com wrote:
>  >
>  > It looks like bitmap_update_sb()'s incrementing of events_cleared (on
>  > behalf of the local member) could be racing with the fact that the NBD
>  > member becomes faulty (whereby making the array degraded).  This
>  > allows the events_cleared to reflect a clean->dirty transition last
>  > occurred before the array became degraded.  My reasoning is: If it was
>  > a clean->dirty transition the bitmap still has the associated dirty
>  > bit set in the local member's bitmap, so using the bitmap to resync is
>  > valid.
>  >
>  > thanks,
>  > Mike
>
>  Thanks for persisting.  I think I understand what is going on now.
>
>  How about this patch?  It is similar to your, but instead of depending
>  on the odd/even state of the event counter, it directly checks the
>  clean/dirty state of the array.

Hi Neil,

Your revised patch works great and is obviously cleaner.

Thanks!

Tested-by: Mike Snitzer <snitzer@gmail.com>
