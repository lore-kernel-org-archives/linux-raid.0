From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
Date: Tue, 17 Jan 2006 09:37:03 -0500
Message-ID: <17357.271.619918.45917@smtp.charter.net>
References: <20060117174531.27739.patches@notabene>
	<1060117065614.27831@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060117065614.27831@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.de> writes:

NeilBrown> Previously the array of disk information was included in
NeilBrown> the raid5 'conf' structure which was allocated to an
NeilBrown> appropriate size.  This makes it awkward to change the size
NeilBrown> of that array.  So we split it off into a separate
NeilBrown> kmalloced array which will require a little extra indexing,
NeilBrown> but is much easier to grow.

Neil,

Instead of setting mddev->private = NULL, should you be doing a kfree
on it as well when you are in an abort state?

John
