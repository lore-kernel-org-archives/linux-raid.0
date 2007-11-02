From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Superblocks
Date: Fri, 2 Nov 2007 10:15:53 -0400
Message-ID: <29a863790711020715h726353bcq99a270494a9f471e@mail.gmail.com>
References: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
	 <18214.45758.794247.651163@notabene.brown>
	 <29a863790710300906w497c0f35yb90c36dadbd2c5e7@mail.gmail.com>
	 <18218.24911.715891.758629@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18218.24911.715891.758629@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Any reason 0.9 is the default? Should I be worried about using 1.0
superblocks? And can I "upgrade" my array from 0.9 to 1.0 superblocks?

Thanks,
Greg

On 11/1/07, Neil Brown <neilb@suse.de> wrote:
> On Tuesday October 30, gcormier@gmail.com wrote:
> > Which is the default type of superblock? 0.90 or 1.0?
>
> The default default is 0.90.
> However a local device can be set in mdadm.conf with e.g.
>    CREATE metdata=1.0
>
> NeilBrown
>
