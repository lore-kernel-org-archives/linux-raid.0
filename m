From: Tim Small <tim@buttersideup.com>
Subject: Re: Controller problems during reshape -> can't continue reshape
 after reboot.
Date: Tue, 21 Aug 2012 08:36:10 +0100
Message-ID: <50333A6A.20507@buttersideup.com>
References: <5032963A.8000908@buttersideup.com> <20120821083709.2e4cfc6c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120821083709.2e4cfc6c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/08/12 23:37, NeilBrown wrote:
> What version of mdadm (mdadm -V) ?
>   

mdadm - v3.1.4 - 31st August 2010

> Try
>   echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded
>   mdadm -S /dev/md1
>
> and then try assembling the array again.
>   

Seems to be working, the reshape is continuing, and an fsck has
completed - thanks.

Tim.

