From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Wed, 20 Nov 2002 08:58:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021120085838.A9206@ti19>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Wed, Nov 20, 2002 at 03:09:18PM +1100
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 20, 2002 at 03:09:18PM +1100, Neil Brown wrote:
>     u32  feature_map     /* bit map of extra features in superblock */

Perhaps compat/incompat feature flags, like ext[23]?

Also, journal information, such as a journal UUID?

Regards,

	Bill Rugolsky

