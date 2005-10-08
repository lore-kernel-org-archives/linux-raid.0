From: "John Stoffel" <john@stoffel.org>
Subject: Re: Anybody know about nforce4 SATA II hot swapping + linux raid?
Date: Sat, 8 Oct 2005 12:08:38 -0400
Message-ID: <17223.61190.917668.850611@smtp.charter.net>
References: <200510071111.46788.andrew@walrond.org>
	<43477836.6020107@gmail.com>
	<62b0912f0510080726ge2436e9ra6d7e8d17d1001ee@mail.gmail.com>
	<200510081555.41159.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200510081555.41159.andrew@walrond.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org, Molle Bestefich <molle.bestefich@gmail.com>, htejun@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Andrew" == Andrew Walrond <andrew@walrond.org> writes:

Andrew> Likewise. I've been using exclusively SATA with linux raid for
Andrew> quite a while now, with great success. But for the super
Andrew> resilient zero downtime servers I now need to deploy, I must
Andrew> be able to swap dead drives without taking the server
Andrew> down. Hence my query.

Andrew> Off-list respondants have recommended 3ware hardware raid
Andrew> products, but throughput concerns on another thread here have
Andrew> really put me off that idea.

Hmm... I've been watching those 3ware discussions with interest as
well, but I haven't seen any commments on how well they work as JBOD
controllers, esp if you get smaller ones with fewer channels and
stripe/mirror between controllers.  If you pair disks between
controllers, then that should limit the downtime, and also improve
performance.

I've been thinking that getting a pair of the two or four change old
74xx series 3ware controllers and then striping across RAID pairs done
between controllers.

John
