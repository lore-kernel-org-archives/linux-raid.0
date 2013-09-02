From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 6/6] mdmon: allow disabling "@dmon" command name at compile
 time
Date: Mon, 02 Sep 2013 20:47:07 +0200
Message-ID: <5224DD2B.50801@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>	<1376677320-12816-7-git-send-email-mwilck@arcor.de>	<20130828151505.222eaa0a@notabene.brown>	<5223774D.50405@arcor.de> <20130902110703.57cbf68a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130902110703.57cbf68a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2013 03:07 AM, NeilBrown wrote:
> Thanks for the details Martin.
> 
> I've taken a different approach which should solve the same problem.
> 
> If you can confirm that this still works I would appreciate it.

Confirmed. Thanks a lot. CentOS6 installation works with upstream mdadm
(git 4e5e54c).

Martin
