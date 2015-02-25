From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/5] Check return of stat() to avoid covscan complaining
Date: Tue, 24 Feb 2015 19:13:15 -0500
Message-ID: <wrfjwq364zms.fsf@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
	<20150225081243.1fe91420@notabene.brown> <wrfj61ar55yq.fsf@redhat.com>
	<20150225090301.5158921d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150225090301.5158921d@notabene.brown> (NeilBrown's message of
	"Wed, 25 Feb 2015 09:03:01 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Tue, 24 Feb 2015 16:56:29 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> > On Tue, 24 Feb 2015 16:00:37 -0500 Jes.Sorensen@redhat.com wrote:
>> >
>> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >> 
>> >> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >> ---
>> >>  Assemble.c | 6 +++++-
>> >>  1 file changed, 5 insertions(+), 1 deletion(-)
>> >> 
>> >> diff --git a/Assemble.c b/Assemble.c
>> >> index 131f871..b392214 100644
>> >> --- a/Assemble.c
>> >> +++ b/Assemble.c
>> >> @@ -688,7 +688,11 @@ static int load_devices(struct devs *devices, char *devmap,
>> >>  			close(dfd);
>> >>  		}
>> >>  
>> >> -		stat(devname, &stb);
>> >> +		if (stat(devname, &stb)) {
>> >> +			pr_err("Unsable to stat(%s) - skipping device.\n",
>> >> +			       devname);
>> >> +			continue;
>> >> +		}
>> >>  
>> >>  		if (c->verbose > 0)
>> >>  			pr_err("%s is identified as a member of %s, slot %d%s.\n",
>> >
>> > I've applied the other 4.  I think I'd rather this one was fixed by changing
>> >   stat(devname,
>> > to
>> >   fstat(dfd,
>> > and keep dfd open a bit longer.
>> >
>> > Does this look OK to you?
>> 
>> I got the warning from covscan because we ignored the return value from
>> stat, so I think you still need to check the return value from fstat()
>> as well.
>
> I hope not.
> You can only get errors from fstat if you do something stupid like passing
> NULL as the stat pointer, or passing a non-open file descriptior.
> So if covscan complains, then covscan is broken.
>
> In contrast, stat can certainly given an error, such a ENOENT, which cannot
> possibly be avoided by not being stupid.

Hmmm OK you got a point, even if the file is removed, it shouldn't
disappear until all users close it.

Cheers,
Jes
