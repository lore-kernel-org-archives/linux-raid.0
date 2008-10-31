From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Fri, 31 Oct 2008 20:18:16 +1100
Message-ID: <18698.52568.828963.755364@notabene.brown>
References: <dledford@redhat.com>
	<200810310102.m9V1236S025014@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Thursday October 30
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Doug Ledford <dledford@redhat.com>, martin f krafft <madduck@debian.org>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Thursday October 30, greg@enjellic.com wrote:
> On Oct 27, 11:13am, Doug Ledford wrote:
> } Subject: Re: RFC - device names and mdadm with some reference to udev.
> 
> Good evening to everyone, hope the week has gone well.
> 
> > > I would really like to have a clear separation of competencies.
> > > Ideally, mdadm never creates any devices but leaves it all to udev,
> > > and all configuration about alternate names ("symlinks") is done in
> > > the udev rules file.
> 
> > This would then require that we have a working udev in our initrd
> > images.  It would greatly increase the complexity of early booting
> > as a result.
> 
> Whatever we do please do not make use of mdadm or startup of arrays
> dependent on udev.  I do SAN's for a living and have had far too many
> phone calls and have spent too much time trying to get boxes messed up
> by udev back on the fabric to want to add any more complication to the
> mix.

I had intended to continue to support the no-udev installations, but
thank you the encouragement that it really is needed and will be used.

Just a clarification:  are you envisaging an installation without udev
at all, or one with udev installed and active, but you don't wont
mdadm to depend on it?  That latter option may be more awkward (I
currently support an environment variable which says "just create the
devices, even if udev appears to be installed").

> 
> The notion of udev certainly has its place but not on a server which
> only cares about four device nodes for its entire operational life.
> 
> Neil your mdadm is a great tool and your contributions via the MD
> stuff are beyond peer, keep up the good work.  But this stuff has to
> get simpler rather than more complex.

Thanks :-)

NeilBrown
