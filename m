From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Sun, 21 Oct 2012 21:14:42 +0400
Message-ID: <50842D82.2000600@msgid.tls.msk.ru>
References: <20120911105908.51681433@notabene.brown> <20120912052941.GA15827@kernel.org> <20120918145710.55394bd4@notabene.brown> <20120919055106.GA1305@kernel.org> <20120919171646.6bc35ba5@notabene.brown> <20120920015655.GB6798@kernel.org> <20121017051113.GA17821@kernel.org> <20121018095601.7aa3238b@notabene.brown> <20121018011735.GA1448@kernel.org> <20121018122959.10bb6c87@notabene.brown> <20121018020134.GB1448@kernel.org> <20121018133657.1bd012f6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121018133657.1bd012f6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[]
>> Set something to a sysfs entry to enable the feature (like my RFC patch does to
>> have a new sysfs entry for the feature), and readd disk. resync then does 'only
>> write mismatch data'. Is this what you asked?
> 
> Yes, that is the sort of thing I was asking for.
> When you say "readd disk" I assume you mean to use the --readd option to
> mdadm.
> The only works when there is a bitmap active on the array,  so relatively few
> blocks will be resynced so does it really matter which approach is taken?
> Always copy, or read-and-test?
> 
> Though maybe you really mean to "--add" the device.  In that case it would
> probably make sense to add some other option to mdadm to say "enable
> read-mostly recovery".  I wonder what a good name would be.
> --minimize-writes ??

That "minimizing" will be a "magnet" for not-so-experienced users, who will
a) enable that option in hope it will run faster, b) will wonder why it is
not the default, and c) will ask why it is so much slow... ;)

And yes it will be slow for regular rebuild of an array when you replace
a disk - because in that case most parts of the new disk will be read AND
written, instead of being JUST written to.

Maybe --compare-when-write.

Note this is useful not only for SSDs, it is very useful in virtual
environments too (and WHY use mdadm in virtual environment is a
different question).  For example, I often test mdadm itself in
a virtual machine with 2 virtual disks.  Initially these disks are
zero-length sparse files, but once a resync/rebuild is run, one of
them will have zeros written all over...

Thanks,

/mjt
