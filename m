From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH] imsm: make messages more understandable
Date: Mon, 19 Dec 2011 09:34:54 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D407021F@IRSMSX101.ger.corp.intel.com>
References: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
 <CABE8wwue6yRmWbtf2KogFDOtcDeNycStYHTYPRN_cmLZ==3AWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwue6yRmWbtf2KogFDOtcDeNycStYHTYPRN_cmLZ==3AWw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Acked-by: Marcin Labun <marcin.labun@intel.com>

> -----Original Message-----
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Friday, December 16, 2011 6:59 PM
> To: Dorau, Lukasz
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Labun, Marcin;
> Ciechanowski, Ed
> Subject: Re: [PATCH] imsm: make messages more understandable
> 
> On Fri, Dec 16, 2011 at 6:04 AM, Lukasz Dorau <lukasz.dorau@intel.com>
> wrote:
> > The printed messages should be more appropriate and understandable
> > for user. If maxsize is equal 0, this means there is no free space
> left
> > on device. If size is greater than maxsize, this means there is not
> enough
> > space to create a new volume of given size.
> >
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
