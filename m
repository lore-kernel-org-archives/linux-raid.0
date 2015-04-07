From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: multi-threaded raid5
Date: Mon, 06 Apr 2015 22:34:15 -0600
Message-ID: <1659926.GihAnxuuSt@balsa>
References: <551AD6AE.4030607@cra.cz> <20150407111157.2200fb0b@notabene.brown>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150407111157.2200fb0b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue 07 Apr 2015 11:11:57 AM NeilBrown wrote:
> On Tue, 31 Mar 2015 19:17:34 +0200 stkoupr <p.kouril@cra.cz> wrote:
> > Hi,
> > 
> > We are testing write performance of md raid5 with SSD array and we are
> > hitting limit which I understand is caused by writes being handled in
> > single thread (md0_raid5 process is eating 100% of 1 CPU core when the
> > test is running). I understood that there is some work in progress which
> > should make write handling multi-threaded. I'd like to ask about the
> > status of this work, is it still in progress or planned?
> > 
> > Regards,
> > Prema
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> See /sys/block/mdXXX/md/group_thread_cnt
> 
> Set it to a bigger number, get more threads.
> 
> Requires 3.12 or later.

What does it mean when that property is set to 0?

> NeilBrown

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
