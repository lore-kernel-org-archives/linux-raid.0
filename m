From: "John Stoffel" <john@stoffel.org>
Subject: Re: bug in bio_map_user_iov
Date: Fri, 19 Nov 2010 15:08:50 -0500
Message-ID: <19686.55634.172818.82198@quad.stoffel.home>
References: <4A89C515-6A74-4C0B-9A81-8FAB6C36AFF0@riverbed.com>
	<20101118110252.498cc1ea@notabene.brown>
	<4845A84C-AE4A-41FF-9147-719D414F27D8@riverbed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4845A84C-AE4A-41FF-9147-719D414F27D8@riverbed.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Demmer <Michael.Demmer@riverbed.com>
Cc: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Michael" == Michael Demmer <Michael.Demmer@riverbed.com> writes:

Michael> Thanks -- I understand your concerns, but unfortunately I
Michael> can't really go into more detail about our use case since
Michael> it's something we use internally. Given which, I understand
Michael> your potential reluctance to take the patch.

Duh, they're an IP accelerator company, so of course the want to
maximize speed from their RAID array on the appliance to the various
ethernet interfaces.  

John
