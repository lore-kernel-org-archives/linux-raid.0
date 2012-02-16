From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Use posix_memalign() for memory used to write bitmaps
Date: Thu, 16 Feb 2012 09:01:15 +0100
Message-ID: <4F3CB7CB.5020505@redhat.com>
References: <1329216733-7081-1-git-send-email-Jes.Sorensen@redhat.com> <20120216141735.4065bf8a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120216141735.4065bf8a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: alexandermurashkin@msn.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/12 04:17, NeilBrown wrote:
> On Tue, 14 Feb 2012 11:52:13 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This makes super[01].c properly align buffers used for the bitmap
>> using posix_memalign() to make sure the writes don't fail in case the
>> bitmap is opened using O_DIRECT.
>>
>> This is based on https://bugzilla.redhat.com/show_bug.cgi?id=789898
>> and an initial patch by Alexander Murashkin.
> 
> hi Jes,
> 
> I suspect that
> 
> http://neil.brown.name/git?p=mdadm;a=commitdiff;h=6ef89052d85b8137b8a7100f761d896ae6f61001
> 
> is the fix you want.  But I'll probably apply yours as well.
> 
> Thanks,
> NeilBrown

Hi Neil,

Thanks, I haven't been able to reproduce the problem locally that
Alexander was seeing, but I suspect you are right. That said, I'd still
vote in favor of using posix_memalign() rather than doing the pointer
juggling, less error prone.

Cheers,
Jes
