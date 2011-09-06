From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH] util: fix seg-fault when trying to kill-subarray in a
 non-existing container
Date: Tue, 6 Sep 2011 14:46:36 -0700
Message-ID: <CAA9_cmcLgPqZ+vzSW+Vxp4VFu4u-FXUuvN653ne+XTuBAA-AMA@mail.gmail.com>
References: <F9123E44003394499FDD2B17C60621D401BDD9@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D401BDD9@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Mon, Sep 5, 2011 at 7:17 AM, Labun, Marcin <Marcin.Labun@intel.com> wrote:
> open_subarray returns valid fd to a container. In case of error shall return
> negative value.
>
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>

Collides with the patch Anna submitted a month ago [1].  Just ping the
old thread.

--
Dan

[1]: http://marc.info/?l=linux-raid&m=131221282424569&w=2
