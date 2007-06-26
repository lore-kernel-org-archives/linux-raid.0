From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: mdadm usage: creating arrays with helpful names?
Date: Tue, 26 Jun 2007 19:54:02 -0400
Message-ID: <20070626235402.GA27852@server>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do I create an array with a helpful name? i.e. "/dev/md/storage"?

The mdadm man page hints at this in the discussion of the --auto option
in the ASSEMBLE MODE section, but doesn't clearly indicate how it's done.

Must I create the device nodes by hand first using MAKEDEV?

Thanks.
