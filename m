From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: md raid acceleration and the async_tx api
Date: Thu, 13 Sep 2007 13:38:17 +0400
Message-ID: <200709131338.17972.yur@emcraft.com>
References: <200709071444.34911.yur@emcraft.com> <0C7297FA1D2D244A9C7F6959C0BF1E520268732A@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E520268732A@azsmsx413.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi Dan,

On Friday 07 September 2007 20:02, you wrote:
> You need to fetch from the 'md-for-linus' tree.  But I have attached
> them as well.
>
> git fetch git://lost.foo-projects.org/~dwillia2/git/iop
> md-for-linus:md-for-linus

 Thanks.

 Unrelated question. Comparing the drivers/md/raid5.c file in the Linus's 
2.6.23-rc6 tree and in your md-for-linus one I'd found the following 
difference in the expand-related part of the handle_stripe5() function:

-		s.locked += handle_write_operations5(sh, 1, 1);
+		s.locked += handle_write_operations5(sh, 0, 1);

 That is, in your case we are passing rcw=0, whereas in the Linus's case the 
handle_write_operation5() is called with rcw=1. What code is correct ?

 Regards, Yuri
