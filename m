From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Migrating RAID 1 volumes to Dual ported disks.
Date: Thu, 05 Nov 2009 03:02:05 +0100
Message-ID: <87639ppw4i.fsf@frosties.localdomain>
References: <ABFC24E4C13D81489F7F624E14891C865AA4C65E@uk-ex-mbx1.terastack.bluearc.com>
	<87r5sf4d6o.fsf@frosties.localdomain>
	<ABFC24E4C13D81489F7F624E14891C865AA4C9A2@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C865AA4C9A2@uk-ex-mbx1.terastack.bluearc.com>
	(Simon Jackson's message of "Wed, 4 Nov 2009 15:24:43 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: "goswin-v-b@web.de" <goswin-v-b@web.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Simon Jackson <sjackson@bluearc.com> writes:

> Sorry, I am probably being thick here, but do you mean something like:
>
> mdadm --create /dev/md10 --level=multipath --raid-devices=2 /dev/sdc /dev/sdd
>
> When I tried this I got:
>
> # mdadm --create /dev/md10 --level=multipath --raid-devices=2 /dev/sdc /dev/sdd
> mdadm: /dev/sdc is too small: 0K
> mdadm: create aborted
> #

If sdc is 0k big then it doesn't look like that is your full disk.

MfG
        Goswin
