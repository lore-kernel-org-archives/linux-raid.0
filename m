From: "John Stoffel" <john@stoffel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 12:35:49 -0500
Message-ID: <22090.5109.242335.358014@quad.stoffel.home>
References: <22090.1097.258820.65463@quad.stoffel.home>
	<CAOS+5GE04m79etfghXJVo1DZtcx1tXKn2FN0Ufb0rMdt+SbA3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GE04m79etfghXJVo1DZtcx1tXKn2FN0Ufb0rMdt+SbA3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Another> Some idea of apps and required response times would likely
Another> get a better response.

Sorry, it's purely a home NFS/KVM server.  A couple of constant VMs
running, but I spin up test VMs fairly frequently to test things out
and play with new setups.

I'm not looking for killer performance, after all it's an AMD Penom II
X4 server!  The CPU is actually quite enough for my needs, it's the
disk that's starting to get old and crufty.

So instead of just getting a bunch of 2Tb disks, maybe it's time to
get fewer large disks in RAID1 paired with 500Gb SSDs (for boot/OS and
lvmcache) to get the system booting.

I'm more concerned with durability and resiliency, than I am with
absolute disk space and performance.  Which is why I'm looking at
fewer spindles.

Does this clarify things?  

John
