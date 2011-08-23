From: Christoph Hellwig <hch@infradead.org>
Subject: external bitmaps on block devices?
Date: Mon, 22 Aug 2011 23:51:55 -0400
Message-ID: <20110823035155.GA12299@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any specific reason to require the external bitmap to be on
a file?  Currently the code requires regular files to call bmap on them,
which is a fairly dangerous thing to start with.  But why don't we just
allow using block devices to store the bitmap directly?
