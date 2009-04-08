From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Recreate raid 10 array
Date: Thu, 09 Apr 2009 00:13:24 +0200
Message-ID: <878wma94l7.fsf@frosties.localdomain>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>
	<49DD1B87.2050804@tmr.com> <1239227842.18515.8.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1239227842.18515.8.camel@cichlid.com> (Andrew Burgess's message
	of "Wed, 08 Apr 2009 14:57:22 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Goswin von Brederlow <goswin-v-b@web.de>, LCID Fire <lcid-fire@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess <aab@cichlid.com> writes:

> It also seems like mdadm could be enhanced to figure stuff like this out
> given intact device superblocks (I suggest --wild-ass-guess as the
> option name)

Like (an imaginary)

mdadm --recreate --assume-clean /dev/mdX /dev/disk1 /dev/disk2

figuring out all the right parameters, number of missing disks and
positions of the existing ones and then writing a new supberlock? The
ultimate --assemble --force option.

MfG
        Goswin
