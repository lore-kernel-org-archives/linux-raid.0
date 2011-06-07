From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: 2.6.39[.1]: raid1 check blocks jbd on other md more than 120 seconds
 -- workaround
Date: Tue, 7 Jun 2011 10:24:35 +0200
Message-ID: <20110607082435.GA2016@janus>
References: <20110602093644.GA8620@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110602093644.GA8620@janus>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did some more testing and apparently the issue can be avoided by
choosing the deadline scheduler instead of cfq. Either configure the
kernel with

	CONFIG_DEFAULT_IOSCHED="deadline"

or select the deadline I/O scheduler per device. In my case:

	echo deadline >/sys/block/sda/queue/scheduler
	echo deadline >/sys/block/sdb/queue/scheduler


-- 
Frank
