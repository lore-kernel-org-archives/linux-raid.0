From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/3] Remove race for starting container devices.
Date: Sat, 22 Oct 2011 10:22:12 +0200
Message-ID: <4EA27D34.1050503@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>	<1319204000-6661-2-git-send-email-Jes.Sorensen@redhat.com> <20111022114906.2e26e66b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111022114906.2e26e66b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

On 10/22/11 02:49, NeilBrown wrote:
> Hi Jes,
> 
>  I have applied the 7 patches you sent.
> 
> However I have question mark over part of this one:
> 
> 
>> > @@ -451,9 +456,10 @@ int Incremental(char *devname, int verbose, int runstop,
>> >  			devnum = fd2devnum(mdfd);
>> >  		close(mdfd);
>> >  		sysfs_free(sra);
>> > -		rv = Incremental(chosen_name, verbose, runstop,
>> > -				 NULL, homehost, require_homehost, autof,
>> > -				 freeze_reshape);
>> > +		rv = Incremental_container(st, chosen_name, homehost,
>> > +					   verbose, runstop, autof,
>> > +					   freeze_reshape);
>> > +		map_unlock(&map);
>> >  		if (rv == 1)
>> >  			/* Don't fail the whole -I if a subarray didn't
>> >  			 * have enough devices to start yet
> You have replaced a call to Incremental with a call to Incremental_container.
> I feel that is significant enough that I would have liked to have seen it
> discussed in the changelog comment.
> 
> You seem have have open-coded Incremental and then removed all the bits that
> you don't need in this case - which is that vast majority of it.
> But you didn't include the call to ->load_content().
> 
> So I have put it back in because I'm sure it must be harmless (Because it was
> there already) but it may not be needed.
> 
> If you have thoughts on this, please let me know.

Hi Neil,

There is a perfectly good explanation for this: The reason is that the
guy who wrote the initial patch is an idiot!

In fact, said idiot spent most of Friday pulling his hairs out trying to
figure out why the modified mdadm would boot fine on a systemd based
system but fail on a sysvinit based system. The result being the patch
bombing you were exposed to yesterday :)

Thanks for catching this, much appreciated!

Jes
