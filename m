From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Mon, 10 Jul 2006 17:27:49 +0200
Message-ID: <bb145bd20607100827i2c92c0a4u6962f654e1a30dba@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <17581.35566.273512.814844@cse.unsw.edu.au>
	 <bb145bd20607061807m7d3a2395hd75b5b338b86e259@mail.gmail.com>
	 <17582.4876.14646.245791@cse.unsw.edu.au>
	 <bb145bd20607070225q7d6f943cx134815d004ad0d78@mail.gmail.com>
	 <bb145bd20607071306t23ad638cu42b90b94e37ff98e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607071306t23ad638cu42b90b94e37ff98e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Nope, EVMS is not the culprit.

I installed the test system from scratch, EVMS nowhere in sight -- it
now boots successfully from a partitionable md array, courtesty of a
yaird-generated initrd I adapted for the purpose. Yay!

Or not. I get the "md: md_d0 still in use." error again :(

This is with Debian's 2.6.15, i. e. without the above patch of course.

The only thing that this configuration and my earlier EVMS one have in
common is that they start the array via initrd. It wasn't even a
similar initrd, first initramfs-tools and now yaird ...

Could this be the source of the problem, Neil? Something breaks due to
the root-fs switching initrds do?

C.
