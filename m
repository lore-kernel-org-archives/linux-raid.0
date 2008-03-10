From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Mon, 10 Mar 2008 15:03:41 +0100
Message-ID: <bb145bd20803100703m68ebd193xce959f2e1b6566cd@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
	 <47CAF30F.7040502@msgid.tls.msk.ru>
	 <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
	 <47CB228D.5020709@msgid.tls.msk.ru>
	 <bb145bd20803021617j1b15c667j96d3ee12829ee75a@mail.gmail.com>
	 <47CB694B.9000807@msgid.tls.msk.ru>
	 <bb145bd20803030038o905e1feib1c1ad42c1b4b042@mail.gmail.com>
	 <bb145bd20803040854i33796bb7n8de956b0d90b76d9@mail.gmail.com>
	 <bb145bd20803042238y5c2d1164o8cac7be9880b550b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803042238y5c2d1164o8cac7be9880b550b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Dropping linux-ide as the HSM violation error was not reproducible
even a second time and I have since switched controllers from Promise
SATA300 TX4s (sata_promise) to Dawicontrol 4320 RAIDs (sil_3124 /
sata_sil24).

BTW the latter can have it's fakeraid firmware disabled via jumper,
which also skips any long option ROM / init sequences during boot.
When doing streaming seqential reads | writes on all four disk block
devices in parallel I get close to 300MB/s in both cases, which is the
limit for both the disk and controller hardware. Great driver!

Before it starts sounding too much like spam - I've only been pounding
the setup for a week, so no idea if it's really stable. Also I haven't
tested for data corruption yet :)

Cheers,

C.
