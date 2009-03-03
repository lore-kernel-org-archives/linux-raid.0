From: Christoph Hellwig <hch@lst.de>
Subject: Future of md multipath
Date: Tue, 3 Mar 2009 19:04:33 +0100
Message-ID: <20090303180433.GA27569@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Just noticed that we still have the old md-based multipath driver
in the tree, which seem to not have gotten any attention since we
got dm multipath.

Is there any reason to keep it or should we deprecate it and kill
it after a couple of kernel releases?
