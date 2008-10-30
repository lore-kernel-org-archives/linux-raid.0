From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm-2.6.7.1 0/3] Misc fixes for mdadm-2.6.7.1
Date: Thu, 30 Oct 2008 12:46:12 +1100
Message-ID: <18697.4580.911971.968652@notabene.brown>
References: <cover.1225306892.git.dledford@redhat.com>
	<18696.59934.872875.299706@notabene.brown>
	<1225322045.26510.86.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Wednesday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 29, dledford@redhat.com wrote:
> On Thu, 2008-10-30 at 09:56 +1100, Neil Brown wrote:
> > That leaves a largish slab of your code that I wasn't really sure
> > what it was adding.
> 
> It was dealing with the fact that is_standard() has more than just two
> return values.  It has -1, 0, and 1 (and 2 in my patch, but you've
> changed yours in such a way that it's not necessary any more).  That
> makes this test fail for certain ARRAY lines:
> 
> > +	if (match && (rv = is_standard(match->devname, &devnum))) {
> > +		devnum = (rv > 0) ? (-1-devnum) : devnum;
> 
> As an example, create an array that doesn't use standard syntax, in my
> case I was testing with /dev/md/root as a partitioned array.  The array
> line in my mdadm.conf looked like this:
> 
> ARRAY /dev/md/root level=raid1 num-devices=2 metadata=0.90 auto=mdp4
> UUID=e38b03c0:444d484e:910e8462:063f083e
> 
> Given a command invocation of mdadm -I <device>, and that device's uuid
> matches the above array line, you really want to use the information in
> the ARRAY line whether is_standard returns -1, 0, or 1.  So, that big
> multiswitch statement was the possible invocations of mdadm -I with a
> device that matches the array UUID in the config file but uses a
> non-standard name, eg someone did a create on /dev/md0, then a -Eb >>
> mdadm.conf, then vi mdadm.conf and add auto=mdp4 to the ARRAY /dev/md0
> line.  Obviously, we would have refused to create the array with that
> name and that auto setting, so I was preserving that behavior at run
> time too.  Hence the size of that section of code.

Ok..... I think I see what you are getting at.

So if the name "/dev/md0" is given in mdadm.conf, we can only create a
non-partitioned array.  But what do we do if 'autof' suggests that a
partitioned array should be created (auto=mdp4)?

I think that if the "auto=mdp4" was on the ARRAY line, then we want to
reject that as a config error.  But if the auto=mdp4 was on the
command line or the CREATE line, then the device name over-rides.
Does that seem reasonable?
That makes me wonder if we have the precedence order of auto= right.
Maybe the ARRAY line should override as it is specific to the array.
Then the command line is next important.  Then the CREATE is the last
default.   I think that is different to the order that you had.
Is there some particular reason that you though the command line
should override in the --incremental case?

Thanks,
NeilBrown
