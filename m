From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [PATCH] md -  Use sector rather than block numbers when splitting
 raid0 requests.
Date: Mon, 20 Oct 2003 17:38:32 +0200
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <3F940178.40CB3AA5@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-xfs-bounce@oss.sgi.com>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Reg. http://marc.theaimsgroup.com/?l=linux-raid&m=106661294929434.

I figured that it's worth mentioning and cross-posting to linux-xfs that
the problem was addressed while troubleshooting xfs on raid0 corruption
under 2.6.0-testX kernel [as discussed at several forums] and it's
confirmed that the patch resolves this problem. A.
