From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Awful RAID5 random read performance
Date: Sun, 31 May 2009 19:19:15 +0200
Message-ID: <874ov1w5po.fsf@frosties.localdomain>
References: <4A21A938.6050907@harddata.com>
	<4A2222E6.2070705@msgid.tls.msk.ru>
	<200905310147.58119.tfjellstrom@shaw.ca>
	<4A227832.1090808@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A227832.1090808@anonymous.org.uk> (John Robinson's message of
	"Sun, 31 May 2009 13:29:38 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: tfjellstrom@shaw.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> Clearly when you're doing this over 4 drives you can have ~400
> seeks/second but that's still limiting you to ~400 reads/second for
> smallish block sizes.
>
> Cheers,
>
> John.

Note that that only holds true for writes or multithreaded reads.
Reading from a single thread will randomly pick one drive (depending
on where it wants to read), wait for it to seek, read one block of
data and repeat. So you get the speed of a single drive no matter how
many drives there are in the raid.

Single thread seek times are only improved with raid1 (raid10) because
there linux can choose the drive with shorter seek time. And that only
saves a tiny amount.


MfG
        Goswin
