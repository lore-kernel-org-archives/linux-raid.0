From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: make the code more readable in the for-loop
Date: Tue, 10 May 2016 17:29:36 -0700
Message-ID: <20160511002936.GA127453@kernel.org>
References: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
 <572FCCD3.4070907@eyal.emu.id.au>
 <20160509035319.GA57828@kernel.org>
 <87inynu4he.fsf@notabene.neil.brown.name>
 <wrfjd1ovrmdp.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfjd1ovrmdp.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: NeilBrown <nfbrown@novell.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org, kernelpatch@126.com
List-Id: linux-raid.ids

On Mon, May 09, 2016 at 04:45:38PM -0400, Jes Sorensen wrote:
> NeilBrown <nfbrown@novell.com> writes:
> > On Mon, May 09 2016, Shaohua Li wrote:
> >
> >> On Mon, May 09, 2016 at 09:33:39AM +1000, Eyal Lebedinsky wrote:
> >>> I do not see how this change makes it clearer. The original form is
> >>> actually a very common and clear
> >>> 	scan an array in reverse order
> >>
> >> People always have different opinions for this stuff. When I read '--j' or
> >> 'j--', I always think extra time what the value of j is. So for me the change
> >> actually makes the code more readable :)
> >
> > If the goal is to make the code more readable, you may as well make it:
> >
> >   for (j = 0; i < ->raid_disk; j++)
> >
> > That will be clearer to most people than the current code, which I don't
> > think is very much clearer than the original (maybe a little bit).
> 
> I agree - I had to read the updated version multiple times to convince
> myself it was doing the same thing as the original.

ok, droped the patch. If Tiezhu Yang is willing to post a new one as neil
suggested, I'll still apply. To be honest I hate the 'j--' and check 'j' stuff.

Thanks,
Shaohua
