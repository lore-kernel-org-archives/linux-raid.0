From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID-6 disk superblock issue
Date: Wed, 14 Dec 2011 14:04:12 -0800
Message-ID: <CAK2H+eeGpUzxTm_Mn-TCdB4uLHtRABnE-NRxcVJ6ChrnT2ggZQ@mail.gmail.com>
References: <jc8kca$mf$1@dough.gmane.org>
	<4EE8F26D.7010608@turmel.org>
	<jcb570$1do$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jcb570$1do$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Telford <ttelford.groups@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 14, 2011 at 1:41 PM, Troy Telford <ttelford.groups@gmail.com> wrote:
<SNIP>
>
> Unfortunately, I'm not sure how to get my current superblock version:
> $ sudo mdadm --examine /dev/md2
> mdadm: No md superblock detected on /dev/md2.
>

use --detail instead:

c2stable ~ # mdadm --detail /dev/md126 | grep Version
        Version : 0.90
c2stable ~ #

HTH,
Mark
