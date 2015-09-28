From: Christoph Hellwig <hch@lst.de>
Subject: Re: raid5-cache I/O path improvements V2
Date: Mon, 28 Sep 2015 16:01:27 +0200
Message-ID: <20150928140127.GA30927@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <D21C6812.74CB%shli@fb.com> <87a8so6t8f.fsf@notabene.neil.brown.name> <20150915215458.GA1943628@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150915215458.GA1943628@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

So the summary is that for now you want me to resend with a patch
to opt into using FUA?

Also do you have a git tree as a baseline somewhere?  I've been collecting
the patches you've sent, but with increasing time I fear I might have
missed something.
