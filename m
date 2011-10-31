From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] Avoid use after free
Date: Mon, 31 Oct 2011 08:41:43 +0100
Message-ID: <4EAE5137.2090003@redhat.com>
References: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>	<1319831451-26704-2-git-send-email-Jes.Sorensen@redhat.com> <20111031104358.24632497@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111031104358.24632497@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 10/31/11 00:43, NeilBrown wrote:
> On Fri, 28 Oct 2011 21:50:50 +0200 Jes.Sorensen@redhat.com wrote:
> 
>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> > 
>> > If picking just one spare disk from the container, jump out of the
>> > loop once freeing the list. Otherwise we end up accessing the list
>> > that we just freed.
>> > 
>> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> > ---
>> >  util.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/util.c b/util.c
>> > index 2cf617d..1bbd87f 100644
>> > --- a/util.c
>> > +++ b/util.c
>> > @@ -1766,6 +1766,7 @@ struct mdinfo *container_choose_spares(struct supertype *st,
>> >  			if (get_one) {
>> >  				sysfs_free(*dp);
>> >  				d->next = NULL;
>> > +				goto out;
>> >  			}
>> >  		} else {
>> >  			*dp = d->next;
>> > @@ -1773,5 +1774,6 @@ struct mdinfo *container_choose_spares(struct supertype *st,
>> >  			sysfs_free(d);
>> >  		}
>> >  	}
>> > +out:
>> >  	return disks;
>> >  }
> 
> Hi Jes,
>   I dont' think patch is needed.
>   The while loop that it jumps out of is
>     while (*dp)
> 
>   at the place you put the goto,
>      dp == &d->next
>   As d->next was just set to NULL, *dp will be NULL, so the loop will
>   exit with the need for a goto.

Hi Neil,

It has to be said, I didn't actually come up with this one on my own, it
was found by the Coverity security checker. I stared at this one for
quite a while. It is well obfuscated. So far I managed to convince
myself several times that you were right and also that Coverity is
correct. In the end I think that you are right indeed and this is a
false positive.

However, in order to avoid the confusion, how about changing the d->next
= NULL assignment to *dp = NULL instead? It should make it a lot more
clear for anyone reading the code what is going on.

Cheers,
Jes
