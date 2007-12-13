From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: optimal IO scheduler choice?
Date: Thu, 13 Dec 2007 08:52:17 +0100
Message-ID: <20071213075217.GA8241@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after reading some interesting suggestions on kernel tuning at:

	http://hep.kbfi.ee/index.php/IT/KernelTuning

I am wondering whether 'deadline' is indeed the best IO scheduler (vs. 
anticipatory and cfq) for a soft raid5/6 partition on a server?

What is the common wisdom on the subject among linux-raid users and 
developers?

Thanks,
