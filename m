From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 25 Mar 2004 16:35:46 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1030470000.1080257746@aslan.btc.adaptec.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <40632804.1020101@pobox.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40632804.1020101@pobox.com>
Content-Disposition: inline
To: Jeff Garzik <jgarzik@pobox.com>, Kevin Corry <kevcorry@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I respectfully disagree with the EMD folks that a userland approach is
> impossible, given all the failure scenarios.

I've never said that it was impossible, just unwise.  I believe
that a userland approach offers no benefit over allowing the kernel
to perform all meta-data operations.  The end result of such an
approach (given feature and robustness parity with the EMD solution)
is a larger resident side, code duplication, and more complicated
configuration/management interfaces.

--
Justin

