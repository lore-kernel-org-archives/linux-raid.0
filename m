From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: How to configure 36 disks ?
Date: Tue, 24 Mar 2009 20:38:35 +0100
Message-ID: <87hc1iemo4.fsf@frosties.localdomain>
References: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Mon, 23 Mar 2009 09:02:14 -0700 (PDT)")
Sender: owner-linux-aio@kvack.org
To: Jon@eHardcastle.com
Cc: Raz <raziebe@gmail.com>, Bill Davidsen <davidsen@tmr.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!

Well, lets see.

Put 3 dual channel SAS controler in the box giving you 6 external SAS
connectors. Buy 6 48x disk enclosures and connect them. Configure them
all as JBOD and you get your 288 disks.

MfG
        Goswin

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
