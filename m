From: "Michael Evans" <mjevans1983@gmail.com>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
Date: Sun, 26 Aug 2007 05:20:45 -0700
Message-ID: <4877c76c0708260520v33bc36bfu24e688a5902912e5@mail.gmail.com>
References: <200708222058.45480.mjevans1983@comcast.net>
	 <18126.21113.981032.286298@notabene.brown>
	 <200708260451.24868.mjevans1983@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753053AbXHZMVA@vger.kernel.org>
In-Reply-To: <200708260451.24868.mjevans1983@comcast.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael J. Evans" <mjevans1983@comcast.net>
Cc: Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Also, I forgot to mention, the reason I added the counters was mostly
for debugging.  However they're also as useful in the same way that
listing the partitions when a new disk is added can be (in fact this
augments that and the existing messages the autodetect routines
provide).

As for using autodetect or not... the only way to skip it seems to be
compiling md's raid support as a module.  I checked 2.6.22's
menuconfig and there's no way for me to explicitly turn it on or off
at compile time.  I also feel that forcing the addition of a boot
parameter to de-activate a broken and deprecated system you aren't
even aware you are getting is somehow wrong.  So if you have over 128
devices for it to scan, as I do on one of my PCs, then it can bring up
an array in degraded mode.

... crud.

I also just noticed, while looking to see if there was some existing
way of detecting if debugging were enabled and to be extra-verbose,
that I left in one of my other debugging variables by mistake.
i_found. Since it's signed, it must have been the variable I was using
to detect where my list matched the existing array in my initial
verification runs.


Are there any other things you'd like to see changed before I submit a
third patch version?
