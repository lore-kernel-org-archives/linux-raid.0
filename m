From: "Steve Pratt" <slpratt@us.ibm.com>
Subject: Linear raid on 2.5.46
Date: Wed, 13 Nov 2002 09:35:42 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OFB2DF08EF.39D9BAB8-ON85256C70.00557220@pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Has anyone tried Linear raid on 2.5.46 + 2.5.47 MD patches?  I have raid 1
working fine but linear segfaults in the kernel in the which_dev function
on the first io request.  Looks like the mmdev structure is garbage.
Wanted to know if this is a known problem before I try to chase it down.

Steve

EVMS Development - http://www.sf.net/projects/evms
Linux Technology Center - IBM Corporation
(512) 838-9763  EMAIL: SLPratt@US.IBM.COM


