From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
Date: Fri, 20 Jan 2006 22:37:25 -0500
Message-ID: <17361.44149.200493.916170@smtp.charter.net>
References: <20060117174531.27739.patches@notabene>
	<1060117065614.27831@suse.de>
	<17357.271.619918.45917@smtp.charter.net>
	<17358.56490.127364.327688@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17358.56490.127364.327688@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> On Tuesday January 17, john@stoffel.org wrote:
>> >>>>> "NeilBrown" == NeilBrown  <neilb@suse.de> writes:
>> 
NeilBrown> Previously the array of disk information was included in
NeilBrown> the raid5 'conf' structure which was allocated to an
NeilBrown> appropriate size.  This makes it awkward to change the size
NeilBrown> of that array.  So we split it off into a separate
NeilBrown> kmalloced array which will require a little extra indexing,
NeilBrown> but is much easier to grow.

>> Instead of setting mddev->private = NULL, should you be doing a kfree
>> on it as well when you are in an abort state?

Neil> The only times I set 
mddev-> private = NULL
Neil> it is immediately after
Neil>    kfree(conf)
Neil> and as conf is the thing that is assigned to mddev->private, this
Neil> should be doing exactly what you suggest.

Neil> Does that make sense?

Now that I've had some time to actually apply your patches to
2.6.16-rc1 and look them over more carefully, I see my mistake.  I
overlooked the assignment of 

	conf = mddev->private 

In the lines just below there, and I see how you do clean it up.  I
guess I would have just done it the other way around:

	conf = kzalloc()
	if (!conf) 
		goto abort:
	.
	.	
	.
	mddev->private = conf;

Though now that I look at it, don't we have a circular reference
here?  Let me quote the code section, which starts of with where I was
confused: 

        mddev->private = kzalloc(sizeof (raid5_conf_t), GFP_KERNEL);
        if ((conf = mddev->private) == NULL)
                goto abort;
        conf->disks = kzalloc(mddev->raid_disks * sizeof(struct disk_info),
                              GFP_KERNEL);
        if (!conf->disks)
                goto abort;

        conf->mddev = mddev;

        if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
                goto abort;


Now we seem to end up with:

	mddev->private = conf;
	conf->mddev = mddev;

which looks a little strange to me, and possibly something that could
lead to endless loops.  But I need to find the time to sit down and
try to understand the code, so don't waste much time educating me
here.

Thanks for all your work on this Neil, I for one really appreciate it!

John
