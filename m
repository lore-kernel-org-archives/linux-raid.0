From: "Arnab Chowdry" <achowdry@socrates.Berkeley.EDU>
Subject: RE: mkraid hangs system
Date: Wed, 12 May 2004 15:27:28 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405122225.i4CMPK60008990@socrates.Berkeley.EDU>
References: <20040512190053.GB7006@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040512190053.GB7006@percy.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>you could dd if=/dev/zero of=/dev/your/disk,

Oddly enough, dd hangs as well. I guess that means it's not a RAID problem.
Very strange though, and I don't have a good intuition about why it's
happening.

dd if=/dev/zero of=/dev/hde 
dd if=/dev/zero of=/dev/hdg
dd if=/dev/zero of=/dev/hdi
dd if=/dev/zero of=/dev/hdk

All of the above hang the system after a few seconds. I'm sorry is this is
now off-topic, but maybe some of you experts have some intuition about why
this might happen? All four of the drives can't have "gone bad" or
something.

-Arnab

