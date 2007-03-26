From: "Ed L. Cashin" <ecashin@coraid.com>
Subject: md bitmaps on 2.6.16.y
Date: Mon, 26 Mar 2007 13:27:13 -0400
Message-ID: <20070326172713.GE19673@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been testing an md RAID 1 created using mdadm 2.6.1 on a
2.6.16.35 kernel, and the initial results are encouraging.  (The
2.6.16.y kernel is a long-term stable branch, unlike most stable
kernels, which are maintained only until the next stable branch
becomes active.)

I see bitmap-related patches with fixes for later kernels being
discussed in the linux-raid mailing list, but I do not see
bitmap-related patches in the ChangeLogs for the 2.6.16.y kernel.  My
hope is that these fixes are only part of the natural churn in the
newer kernel branches and are not needed for the 2.6.16.y kernels.

Are there any known issues that would make the use of md bitmaps in a
2.6.16.y kernel problematic?  I do see an important RAID 1 fix in
2.6.16.40, so I know that 2.6.16.35 isn't good enough.

-- 
  Ed L Cashin <ecashin@coraid.com>
