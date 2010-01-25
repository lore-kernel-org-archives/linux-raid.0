From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Fw: Why does one get mismatches?
Date: Mon, 25 Jan 2010 11:37:04 +0100
Message-ID: <87y6jmxygf.fsf@frosties.localdomain>
References: <644690.69223.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <644690.69223.qm@web51302.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Mon, 25 Jan 2010 02:07:11 -0800 (PST)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> Now the array is completely dismantled and I am running bad blocks on the drives but I am on the last 2 of the 7 drives and I still have no leads. No bad blocks, no offline uncorrectable, no pending sectors no dmesg errors no nothing. I have absolutely no leads what so ever.
>
> The only thing i have left to try is a full Mem test and disconnect and reseat the additional sata controllers, oh and buy 7 new sata cables incase 1 is bad.

The problem with badblocks is that it writes the same pattern
everywhere. If the problem is that data gets read/written to the wrong
block then that will not show up.

Try formating each drive and run fstest [1] on it. Or some other test
that verifies data integrity using different patterns per block.

MfG
        Goswin

[1] http://mrvn.homeip.net/fstest/
