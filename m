From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
Date: Fri, 2 Apr 2010 16:36:14 +1100
Message-ID: <20100402163614.11ff0fc9@notabene.brown>
References: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
	<20100401060922.GA15461@maude.comedia.it>
	<4BB4CA69.7060705@redhat.com>
	<66C59AD0932712458090B447266D638CD3CE3017@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638CD3CE3017@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Thu, 1 Apr 2010 22:31:40 +0100
"Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> >-----Original Message-----
> >From: Doug Ledford [mailto:dledford@redhat.com]
> >Sent: Thursday, April 01, 2010 6:32 PM
> >To: Hawrylewicz Czarnowski, Przemyslaw; Neil Brown; linux-
> >raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> >Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
> >
> >On 04/01/2010 02:09 AM, Luca Berra wrote:
> >> On Wed, Mar 31, 2010 at 09:50:40PM +0100, Hawrylewicz Czarnowski,
> >> Przemyslaw wrote:
> >
> >>> int mdmon_pid(int devnum)
> >>> @@ -1502,7 +1523,11 @@ int mdmon_pid(int devnum)
> >>>        char pid[10];
> >>>        int fd;
> >>>        int n;
> >>> -       sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
> >>> +       char *devname = devnum2devname(devnum);
> >>> +
> >>> +       sprintf(path, "%s/%s.pid", pid_dir, devname);
> >>> +       free(devname);
> >>> +
> >>>        fd = open(path, O_RDONLY | O_NOATIME, 0);
> >>>
> >>>        if (fd < 0)
> >> why?
> >
> >Looks like it leaks memory in the old implementation.
> For both mdmon_running and mdmon_pid there is a memory leak with strdup.
> Did I miss something?

Well you missed that when you fix a memory leak, you should create a patch
which just fixes memory leaks, you should put a comment on the top of the
patch saying that it fixes memory leaks, and you should post it.  Not bury
the memory-leak fix in amongst lots of other changes.  Doing it that way
would make review a lot faster.

NeilBrown

> 
> >
> >--
> >Doug Ledford <dledford@redhat.com>
> >              GPG KeyID: CFBFF194
> >	      http://people.redhat.com/dledford
> >
> >Infiniband specific RPMs available at
> >	      http://people.redhat.com/dledford/Infiniband
> 
> 
> --
> Best Regards,
> Przemyslaw Hawrylewicz-Czarnowski
> Software Development Engineer

