From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 1/3] FIX: Do not allow for multiple reshape_array()
 execution during reshape_container() call
Date: Wed, 14 Dec 2011 08:19:37 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A05FAB3@IRSMSX101.ger.corp.intel.com>
References: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
 <20111214190857.7ab891dd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214190857.7ab891dd@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, December 14, 2011 9:09 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH 1/3] FIX: Do not allow for multiple reshape_array()
> execution during reshape_container() call
> 
> On Tue, 13 Dec 2011 11:12:10 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > It can happen during reshape restart that reshape_array() can exit
> > without error (e.g. Grow.c:1915) and reshape is not moved to next array.
> > reshape_array() is called again for the same device.
> > Do not allow for such execution and check if last reshaped array is
> > not the current one.
> > This patch can be treat not as solution, but it allows for such errors
> > detection.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> Hi Adam.
>  I'm afraid I understand the problem that requires this patch.
> Could you please outline how it can happen that "reshape_array() can exit
> without error (e.g. Grow.c:1915) and reshape is not moved to next array."

It happens (Lukasz Dorau saw it), when mdadm assembles array in initramfs and even mdadm is directed to assemble array only (--freeze-reshape is used),
filesystetem pivot occurs too early and array is in not stable state. During reshape continuation analyse_change() returns 0 in backup_blocks and reshape_container calls reshape_array() again.
This time restart variable is cleaned and mdadm finishes with error. For now I wanted to put better error description to help Lukasz in problem investigation.
At this moment I do not know more details, but probably when I finish checking raid0 md problem (using patch you sent) I'll go in to tihis.

> 
> Also the comment in the code seems to be incomplete.  Could you complete
> it please?
> Thanks.
> 
> The other 2 patches in the series are fine.
> 
> Thanks,
> NeilBrown
> 
> > ---
> >
> >  Grow.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 184a973..1828f83 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2462,6 +2462,7 @@ int reshape_container(char *container, char
> > *devname,  {
> >  	struct mdinfo *cc = NULL;
> >  	int rv = restart;
> > +	int last_devnum = -1;
> >
> >  	/* component_size is not meaningful for a container,
> >  	 * so pass '-1' meaning 'no change'
> > @@ -2546,6 +2547,17 @@ int reshape_container(char *container, char
> *devname,
> >  		if (!adev)
> >  			adev = content->text_version;
> >
> > +		if (last_devnum == mdstat->devnum) {
> > +			/* do not allow for reentry reshape_array()
> > +			 * for the same device. It can happen when
> resahpe_array
> This one.  Should there be more to this sentence?


You are right, I've missed it. I'll correct comment and resend this patch.

BR
Adam


> 
> NB
> 
> 
> > +			 */
> > +			printf(Name ": Multiple reshape execution detected
> for "
> > +			       "device  %s.", adev);
> > +			close(fd);
> > +			break;
> > +		}
> > +		last_devnum = mdstat->devnum;
> > +
> >  		sysfs_init(content, fd, mdstat->devnum);
> >
> >  		rv = reshape_array(container, fd, adev, st,

