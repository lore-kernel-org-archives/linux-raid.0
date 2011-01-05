From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/3] deal with imsm spares in Incremental
Date: Wed, 5 Jan 2011 14:44:23 +1100
Message-ID: <20110105144423.3839aac8@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FDE@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FDE@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 4 Jan 2011 15:03:04 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Hi Neil,
> Some time ago you suggested that Incremental may migrate spares from spare-container
> when it is ready to start array as it is impossible to know array's domain before we have all members.
> Here are patches that do this.
> First two patches modify slightly existing functions to be able to use them in Incremental too.
> Third one does the work.
> Regards
> Anna

Thanks.  Looks good.
> 
> 0001-Use-one-function-chosing-spares-from-container.patch

I rearrange some of the code in this one as you left a generic function in
super-intel.c.  I moved container_chose_spares to util.c and renamed it to
container_choose_spares (and extra 'o').

> 0002-move_spare-function-modified-and-moved-to-Manage.c.patch
applied.

> 0003-Incremental-move-suitable-spares-to-container-when-s.patch

I rearranged the code a little bit to reduce the level of indentation
required - it was getting *really* deep!

Thanks,

NeilBrown



>  
>  Incremental.c |   45 +++++++++++++++++++++++++
>  Manage.c      |   44 ++++++++++++++++++++++++
>  Monitor.c     |  102 +++++++++-----------------------------------------------
>  mdadm.h       |    7 +++-
>  super-intel.c |   46 ++++++++++++++++++++-----
>  5 files changed, 149 insertions(+), 95 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

