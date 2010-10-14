From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: Preventing a RAID device from starting until all disks are ready
Date: Thu, 14 Oct 2010 12:31:39 -0700 (PDT)
Message-ID: <5533.55464.qm@web65403.mail.ac4.yahoo.com>
References: <4CB7292A.6040209@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CB7292A.6040209@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Thu, 10/14/10, Iordan Iordanov <iordan@cdf.toronto.edu> wrote:

> We have iscsi targets for drives in our array, and we make
> sure that we've logged into all 30 of our drives before we
> continue to enable mdadm (we literally count the number of
> iscsi sessions open). You can try counting the number of
> block devices present (in /dev/block) that match a certain
> pattern, or perhaps your fiber channel driver offers an even
> more convenient facility in /dev.

It seems like the simplest way to do this would be to have two mdadm.conf files; one for the root arrays that need to come up right away, one for the FC/iSCSI arrays that need to wait.

Is either of these ideas:

 - run two "mdadm --monitor" processes simultaneously, one for each set of arrays, or

 - specify two config file arguments to "mdadm --monitor"

...possible?

Thanks.

Andrew




