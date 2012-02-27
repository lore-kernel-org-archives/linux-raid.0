From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: MD and rotational attribute
Date: Sun, 26 Feb 2012 19:18:12 -0500
Message-ID: <yq18vjpuo1n.fsf@sermon.lab.mkp.net>
References: <20120220122022.GA7466@x2.net.home>
	<20120227104230.125cb9e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120227104230.125cb9e2@notabene.brown> (NeilBrown's message of
	"Mon, 27 Feb 2012 10:42:30 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, "Martin K.Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil,

Neil> (I would say that the name 'rotational' is a bug - the issues here
Neil> is really whether seek is fast or slow is it not??... but no
Neil> matter).

Both the ATA and SCSI specs use the term 'rotational' which I guess is
how we ended up with that name.


Neil> What do you think Martin?  Should QUEUE_FLAG_NONROT move to
Neil> queue_limits much like QUEUE_FLAG_CLUSTER did?

Absolutely. I posted some patches converting both the nonrot and
discard/secure discard queue flags a while back but they didn't go
in. I'll freshen up the kit and resend...

-- 
Martin K. Petersen	Oracle Linux Engineering
