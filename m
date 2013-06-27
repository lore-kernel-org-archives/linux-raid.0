From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 1/2] select_devices: fix scanning of container members
 with dev list
Date: Thu, 27 Jun 2013 21:38:15 +0200
Message-ID: <51CC94A7.9070904@arcor.de>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de> <20130624165547.0c0bd93b@notabene.brown> <51CC812C.3030500@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51CC812C.3030500@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I wrote:
> Well, the problem might be fixed differently by having "mdadm -Dbv" in
> the container case print the container device.

I have come up with another patch, based on that idea, that I'll submit
in a minute. Do you like it better?

Regards,
Martin
