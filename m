From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: make messages more understandable
Date: Fri, 16 Dec 2011 09:59:04 -0800
Message-ID: <CABE8wwue6yRmWbtf2KogFDOtcDeNycStYHTYPRN_cmLZ==3AWw@mail.gmail.com>
References: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, Dec 16, 2011 at 6:04 AM, Lukasz Dorau <lukasz.dorau@intel.com> wrote:
> The printed messages should be more appropriate and understandable
> for user. If maxsize is equal 0, this means there is no free space left
> on device. If size is greater than maxsize, this means there is not enough
> space to create a new volume of given size.
>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
