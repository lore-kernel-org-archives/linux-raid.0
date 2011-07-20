From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Wed, 20 Jul 2011 12:39:58 +0200
Message-ID: <j06b9u$9aj$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org> <j03m2p$jn1$1@dough.gmane.org> <j041j1$ttf$1@dough.gmane.org> <j046mj$1pn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j046mj$1pn$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/19/2011 05:06 PM, David Brown wrote:
> It certainly sounds like a safe procedure, but I can see why you feel it's not quite as elegant as
> it could be. You will also be "discarding" blocks that have never been written (at least, not since
> the last discard...) - is there much overhead in that?

Luckily the SSDs we use do not require significant time to process a discard
on areas that were already free - e.g. discarding ~ 250G of SSD space that is
already empty this way takes only ~ 10 seconds.

Regards,

Lutz Vieweg


