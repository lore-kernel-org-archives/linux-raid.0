From: Krzysztof Adamski <k@adamski.org>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 12:04:02 -0500
Message-ID: <1327338242.9581.0.camel@oxygen.netxsys.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
	 <4F1D89B9.9080802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D89B9.9080802@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes.Sorensen@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

How about --prepivot

K

On Mon, 2012-01-23 at 11:24 -0500, Doug Ledford wrote:
> On 01/23/2012 06:18 AM, Jes.Sorensen@redhat.com wrote:
> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> > 
> > Hi,
> > 
> > Here is v2 of the systemd/dracut fixes for preboot handling in
> > mdadm/mdmon. I have changed the argument over from --initrd to
> > --preboot as Neil suggested, as well as fixed up the minor code nits
> > and added documentation to the man pages.
> > 
> > It shows up that I didn't need to add a separate enum for the command
> > line arguments in mdmon since mdadm.h gets pulled in so we can reuse
> > those. If we find that to be an issue, we can always create a separate
> > one later.
> 
> I'm not sure I like --preboot.  I understand the difficulty in finding
> just the right option name, but to me, preboot sounds like an option you
> would use if you are doing pre-processing of something for a later
> invokation to use.  And that isn't the case here, so the gut level
> understanding won't match up with the man page/help output understanding
> and I try to avoid that as much as possible.  Since the distinct element
> is that we want to keep running both before and after the normal root
> filesystem is mounted and we want all files we open to be off of the
> root filesystem namespace, maybe --offroot (which is odd enough by
> itself to forestall any gut reactions and prompt a trip to the help/man
> pages as opposed to guessing what the option means)?
> 
> > Cheers,
> > Jes
> > 
> > Jes Sorensen (4):
> >   mdmon: Use getopt_long() to parse command line options
> >   Add --preboot argument to mdadm
> >   Add --preboot argument to mdmon
> >   Spawn mdmon with --preboot if mdadm was launched with --preboot
> > 
> >  ReadMe.c   |    5 +++++
> >  mdadm.8.in |   12 ++++++++++++
> >  mdadm.c    |   10 ++++++++++
> >  mdadm.h    |    3 +++
> >  mdmon.8    |   12 +++++++++++-
> >  mdmon.c    |   60 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
> >  util.c     |   17 +++++++++++++----
> >  7 files changed, 103 insertions(+), 16 deletions(-)
> > 
> 
> 


