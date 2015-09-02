From: Christoph Hellwig <hch@lst.de>
Subject: Re: fix use after free in raid5-cache
Date: Wed, 2 Sep 2015 19:22:55 +0200
Message-ID: <20150902172255.GA25723@lst.de>
References: <1441203288-22515-1-git-send-email-hch@lst.de> <20150902165522.GA2792971@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150902165522.GA2792971@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: neilb@suse.de, dan.j.williams@intel.com, linux-raid@vger.kernel.org, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Ok, I spotted the break there now.  Feel free to rebase it and please
push your current tree out, as I have a bunch of other changes pending.
