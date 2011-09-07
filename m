From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] kill-subarray: fix, cannot kill-subarray with
 unsupported metadata
Date: Wed, 7 Sep 2011 14:31:11 +1000
Message-ID: <20110907143111.499ae36e@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D401BE07@IRSMSX101.ger.corp.intel.com>
	<CABE8wwsfrdgZcHzOdTpA-EM1R8fknw7hCT1+VHGus5h-Pa-3pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwsfrdgZcHzOdTpA-EM1R8fknw7hCT1+VHGus5h-Pa-3pA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, 6 Sep 2011 12:16:43 -0700 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Mon, Sep 5, 2011 at 7:23 AM, Labun, Marcin <Marcin.Labun@intel.com> wrote:
> > Subject: [PATCH] kill-subarray: fix, cannot kill-subarray with unsupported metadata
> >
> > container_content retrieves volume information from disks in the container.
> > For unsupported volumes the function was not returning mdinfo. When all volumes
> > were unsupported the function was returning NULL pointer to block actions on the volumes.
> 
> Isn't this the purpose of ->ignore_hw_compat?
> 
> So we could do something simpler like the following instead?
> 
> diff --git a/Kill.c b/Kill.c
> index b841a5b..11b27a6 100644
> --- a/Kill.c
> +++ b/Kill.c
> @@ -97,7 +97,9 @@ int Kill_subarray(char *dev, char *subarray, int quiet)
> 
>         memset(st, 0, sizeof(*st));
> 
> +       st->ignore_hw_compat = 1;
>         fd = open_subarray(dev, subarray, st, quiet);
> +       st->ignore_hw_compat = 0;
>         if (fd < 0)
>                 return 2;

While that is a *much* nicer patch, I don't think it will actually address
the problem.
You would at least need container_content_imsm to ignore
imsm_check_attributes if ->ignore_hw_compat was set.

However I think things are getting a bit messy here and need to be cleaned up.

Marcin's patch has the advantage that it treats the existence of a bad block
log and incompatible attributes in much the same way.
However I don't like:
  - the increase in number of magic flag bits
  - the editing of the list of arrays returned by container_content
  - the error messages being printed by super-intel.c

I think I would like:
 - container_content always returns info about all arrays, so Examine and
   Kill can work properly
 - it sets a single flags (MD_SB_INVALID??) to say that the array cannot be
   assembled or manipulated, and maybe stored a message string in the 'info'
   so that common code can print it when it choses to ignore an array
 - common code checks and ignores MD_SB_INVALID arrays as needed rather than
   having them be removed from the list.

Reasonable??

Thanks,
NeilBrown

