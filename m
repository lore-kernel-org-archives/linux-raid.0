From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 23:17:02 +0100
Message-ID: <4AF9E65E.6070803@rabbit.us>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>    <4AF5268D.60900@eyal.emu.id.au>    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>    <87iqdlaujb.fsf@frosties.localdomain> <20091108160433.GA5338@lazy.lzy>    <4AF85DCB.3030909@tmr.com> <df8de4eb79e2bf13d0e5c2c83cdc7cf1.squirrel@neil.brown.name> <4AF9AB6C.4010608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9AB6C.4010608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Well, I do get a *ton* of mismatches in swap, I just ran a check and got
> 12032 in the mismatch count. Another raid1 on partitions of the same
> drives showed 128, which still bothers me, since /boot hasn't changed in
> months.

I can answer the /boot part (I did a hexdiff on all the raid members to
come up with this): http://marc.info/?l=linux-raid&m=120988628322707&w=2

Cheers
