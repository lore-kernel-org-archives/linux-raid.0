From: Neil Brown <neilb@suse.de>
Subject: Re: Superblocks
Date: Fri, 2 Nov 2007 10:29:19 +1100
Message-ID: <18218.24911.715891.758629@notabene.brown>
References: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
	<18214.45758.794247.651163@notabene.brown>
	<29a863790710300906w497c0f35yb90c36dadbd2c5e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Greg Cormier on Tuesday October 30
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 30, gcormier@gmail.com wrote:
> Which is the default type of superblock? 0.90 or 1.0?

The default default is 0.90.
However a local device can be set in mdadm.conf with e.g.
   CREATE metdata=1.0

NeilBrown
