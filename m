From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: md raid acceleration and the async_tx api
Date: Thu, 30 Aug 2007 18:57:09 +0400
Message-ID: <200708301857.09564.yur@emcraft.com>
References: <200708271249.48684.yur@emcraft.com> <0C7297FA1D2D244A9C7F6959C0BF1E52025B10C6@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E52025B10C6@azsmsx413.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Wolfgang Denk <wd@denx.de>, dzu@denx.de
List-Id: linux-raid.ids


 Hi Dan,

On Monday 27 August 2007 23:12, you wrote:
> This still looks racy...  I think the complete fix is to make the
> R5_Wantfill and dev_q->toread accesses atomic.  Please test the
> following patch (also attached) and let me know if it fixes what you are
> seeing:

 Your approach doesn't help, the Bonnie++ utility hangs up during the 
ReWriting stage.

 Note that before applying your patch I rolled my fix in the 
ops_complete_biofill() function back. Do I understand it right that your 
patch should be used *instead* of my one rather than *with* it ?

 Regards, Yuri
