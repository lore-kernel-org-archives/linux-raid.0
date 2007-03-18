From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 array ,  part id 'fd' not assembling at boot .
Date: Mon, 19 Mar 2007 08:40:21 +1100
Message-ID: <17917.45509.654906.432675@notabene.brown>
References: <Pine.LNX.4.64.0703161838110.11877@filesrv1.baby-dragons.com>
	<17915.32343.270875.583164@notabene.brown>
	<45FC3158.3020104@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Saturday March 17
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday March 17, davidsen@tmr.com wrote:
> Neil Brown wrote:
> >
> > In-kernel auto-assembly using partition type 0xFD only works for
> > metadata=0.90.  This is deliberate.
> >
> > Don't use 0xFD partitions.  Use mdadm to assemble your array, either
> > via an initrd or (if it don't hold the root filesystem) via an init.d
> > script.
> Could you clarify why someone thought it was a good idea to make it 
> complex for users to move to current versions of the superblock? Having 
> worked with users for way too many years, expecting end users to diddle 
> init scripts without shooting themselves in the foot is optimism not 
> justified by past results. At least past results as observed by me ;-)

That's a loaded question isn't it?  Of course no-one thought it was a
good idea to make life complex for anyone.

However I do not want to perpetuate a past design mistake of
auto-assembling raid array based solely on partition type, and didn't
want to burden version-1 superblocks with the information required to
support that.  So I didn't. 

But neither am I forcing anyone to use version-1 metadata.  Most of
the new functionality I have made available in v-1 metadata has also
been added to v-0.90 metadata (not quite all, but there are very few
needs that would drive someone to use v-1).

If someone is keen to use the newest features, then I am happy with
that, and am happy to provide support and advice.  In doing so I learn
about ways that mdadm can be improved to make life easier.  But if you
want to use the newest features, you need to understand all the
implications there-of.

As a contrast, Debian does force (or strongly encourages) people to use
version-1 metadata by putting "CREATE metadata=1" in
/etc/mdadm/mdadm.conf.
But then Debian also provides all the infrastructure for building an
initrd that assembles md arrays for you quite smoothly.   So they
provide a complete package that just works (most of the time).

I primarily provide functionality.  It needs to work for everyone:
those with legacy configurations that I would not recommend using on
new systems, and those who build new systems with different
requirements.  I have to provide a variety of options. It is up to the
system integrator to choose which bits of functionality to use.

I would be good to create a document discussing the various issues and
setting out the preferred config approach for new systems, and I have
considered doing this, but unfortunately it hasn't happened yet.

It would suggest:
 - If root/swap are on an md device, use an initrd to assemble those
    (swap needed for resume-from-hibernate)
 - Set homehost in mdadm.conf and use "mdadm -As" to auto-assemble
   everything that is meant to be assembled on this host.
 - Assemble all arrays as partitionable.
 - Use version-1.1 metadata (superblocks at the start cause less
   confusion I think)
 - run 'repair' every month and don't worry about the mismatch_cnt.

That's all I can think of at the moment.

NeilBrown
