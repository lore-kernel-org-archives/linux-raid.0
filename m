From: Shaohua Li <shli@kernel.org>
Subject: Re: [GIT PULL] MD update for 4.12
Date: Wed, 3 May 2017 11:38:21 -0700
Message-ID: <20170503183821.yl72sm3tha4el6ql@kernel.org>
References: <20170501225048.whxlxsoebnxcfyto@kernel.org>
 <CA+55aFxD4mukK20ukU6LySD_Ro9XD+k1SU5O3+3-A67EG8ER6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxD4mukK20ukU6LySD_Ro9XD+k1SU5O3+3-A67EG8ER6w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, May 03, 2017 at 10:27:47AM -0700, Linus Torvalds wrote:
> On Mon, May 1, 2017 at 3:50 PM, Shaohua Li <shli@kernel.org> wrote:
> >
> > Please pull MD update for 4.12. There are conflicts between MD tree and block
> > tree, so I did a merge before the pull request.
> 
> I pulled this, but *please* don't do those broken merges.
> 
> Why is it broken? Let me just count the merge message in its entirety:
> 
>     "Merge branch 'md-next' into md-linus"
> 
> that's it. That doesn't really help anything. There is *no*
> explanation for the merge. No "What", no "Why", nothing to explain why
> you are merging with that _particular_ point in history.
> 
> In contrast, when I do merges, even if I don't have a lot of commit
> message (and I try to have explanations - I will complain to
> submaintainers if they don't give me enough information), there's very
> much some implied information: "somebody asked Linus to pull this
> point". I don't just randomly merge random points in development.
> 
> That merge, in contrast, very much merged completely random points in time.
> 
> In fact, the particular point you merged makes no sense at all and is
> probably the *worst* possible kind of merge point. It's not just a
> random point in time (me having just merged the LED drivers), it's a
> point in the middle of the first day of the merge window. Which is
> just about the *worst* possible thing to do, because that's often the
> point that is the least reliable.
> 
> Seriously. DO NOT DO THIS!
> 
> I'm perfectly happy handling merge conflicts. I *much* prefer that
> over this kind of "easy but crappy merge".
> 
> I appreciate it a lot if submaintainers do a "test merge" to see what
> might conflict, and then explain what the conflict is and why it
> happened in the pull request. That's absolutely lovely - it's a nice
> heads-up about what happened, and it shows that you cared and you knew
> about the conflict, and it makes me all warm and fuzzy.
> 
> But this kind of random bad merge of me tree during the most volatile
> time of the merge window? That's just wrong. It doesn't even help me,
> I probably spent about as much time looking at the conflct with your
> merge in place as I would have when I resolved it, and then spent more
> time writing this "please don't do this" rant than it would have taken
> me to just do the merge.
> 
> Yes, occasionally the conflicts end up being nasty enough that I ask
> people to verify my work.  And _very_ occasionally I might ask you to
> actually do the merge for me, but I don't recall when something was
> really messy enough for that to happen. This did not look that messy
> at all.
> 
> I have sent a variation of this email to people (and the mailing list)
> probably approaching a hundred times over the 10+ years we've used
> git.
> 
> Don't do back-merges unless you have a *really* good reason for it,
> and if you have that reason, you had damn well *explain* that reason
> in the merge message.
> 
> And "make the merge easier for Linus" is _never_ a good reason. If you
> want to make life easier for me, please just do that test-merge and
> explanation of what's going on: lots of maintainers do that, and I
> really appreciate it. If you feel the merge isn't trivial, you can
> even make the merge available as a ".. this is how I merged it" branch
> - when people do that, I will actually end up doing the merge on my
> own first (without looking at your merge), and then re-do the whole
> thing *with* your merge in a test-branch, and verify the differences.
> Because the differences (if there are any - it's seldom the case other
> than trivial whitespace or other slight differences) are actually
> really interesting markers for me, and tend to show where subtle
> issues were.
> 
> But don't ask me to pull a pre-merged thing that just hides the conflicts.
> 
> Please please please don't do this.

Get it, thanks for the explanation!
