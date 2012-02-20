From: "RANSOM, Tony" <tony.ransom@baesystems.com>
Subject: RE: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 19:45:24 +1030
Message-ID: <807765805CA0DF48898D4C016E982BFC065A6D9BF6@MWLSVEXM002.au.baesystems.com>
References: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
	<20120220162915.43b4f451@notabene.brown>
	<807765805CA0DF48898D4C016E982BFC065A6D9BF5@MWLSVEXM002.au.baesystems.com>,<20120220201159.6cd1633d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120220201159.6cd1633d@notabene.brown>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

>Yes.
>Somehow both sdb and sdb3 have a superblock for the same array.  Must have
>been a typo somewhere I suspect.
>You should remove the one you don't want:

>  mdadm --zero-superblock /dev/sdb

>then it should all work nicely again.


Unfortunately, the above command gave the following error :

root@server2:~# mdadm --zero-superblock /dev/sdb
mdadm: Couldn't open /dev/sdb for write - not zeroing

Do you know how to work around?

Tony
"Warning:
The information contained in this email and any attached files is
confidential to BAE Systems Australia. If you are not the intended
recipient, any use, disclosure or copying of this email or any
attachments is expressly prohibited.  If you have received this email
in error, please notify us immediately. VIRUS: Every care has been
taken to ensure this email and its attachments are virus free,
however, any loss or damage incurred in using this email is not the
sender's responsibility.  It is your responsibility to ensure virus
checks are completed before installing any data sent in this email to
your computer."


