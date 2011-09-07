From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] util: fix seg-fault when trying to kill-subarray in a
 non-existing container
Date: Wed, 7 Sep 2011 14:11:16 +1000
Message-ID: <20110907141116.0d4ed051@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D401BDD9@IRSMSX101.ger.corp.intel.com>
	<CAA9_cmcLgPqZ+vzSW+Vxp4VFu4u-FXUuvN653ne+XTuBAA-AMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcLgPqZ+vzSW+Vxp4VFu4u-FXUuvN653ne+XTuBAA-AMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Tue, 6 Sep 2011 14:46:36 -0700 Dan Williams <dan.j.williams@gmail.com>
wrote:

> On Mon, Sep 5, 2011 at 7:17 AM, Labun, Marcin <Marcin.Labun@intel.com> wrote:
> > open_subarray returns valid fd to a container. In case of error shall return
> > negative value.
> >
> > Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> 
> Collides with the patch Anna submitted a month ago [1].  Just ping the
> old thread.
> 
> --
> Dan
> 
> [1]: http://marc.info/?l=linux-raid&m=131221282424569&w=2


Thanks for the ping - applied (but you know that...)

NB
