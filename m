From: greg@enjellic.com
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Thu, 30 Oct 2008 20:02:03 -0500
Message-ID: <200810310102.m9V1236S025014@wind.enjellic.com>
References: <dledford@redhat.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Doug Ledford <dledford@redhat.com>
       "Re: RFC - device names and mdadm with some reference to udev." (Oct 27, 11:13am)
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, martin f krafft <madduck@debian.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Oct 27, 11:13am, Doug Ledford wrote:
} Subject: Re: RFC - device names and mdadm with some reference to udev.

Good evening to everyone, hope the week has gone well.

> > I would really like to have a clear separation of competencies.
> > Ideally, mdadm never creates any devices but leaves it all to udev,
> > and all configuration about alternate names ("symlinks") is done in
> > the udev rules file.

> This would then require that we have a working udev in our initrd
> images.  It would greatly increase the complexity of early booting
> as a result.

Whatever we do please do not make use of mdadm or startup of arrays
dependent on udev.  I do SAN's for a living and have had far too many
phone calls and have spent too much time trying to get boxes messed up
by udev back on the fabric to want to add any more complication to the
mix.

The notion of udev certainly has its place but not on a server which
only cares about four device nodes for its entire operational life.

Neil your mdadm is a great tool and your contributions via the MD
stuff are beyond peer, keep up the good work.  But this stuff has to
get simpler rather than more complex.

Best wishes for a pleasant weekend to everyone.

}-- End of excerpt from Doug Ledford

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"C++ is designed to allow you to express ideas, but if you don't have
 any ideas or don't have any clue about how to express them, C++
 doesn't offer much help."
                                -- Bjarne Stroustrup
                                   Technology Review
