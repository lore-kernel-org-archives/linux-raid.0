From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Is trim/discard supported on LVM RAID logical volume?
Date: Tue, 29 Nov 2016 23:09:49 +0100
Message-ID: <20161129220949.GA4035@metamorpher.de>
References: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
 <CAJCQCtSpOfMvgfxOFvQtM=zcOnyoqvu3GregmW9NS5j9auRuyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtSpOfMvgfxOFvQtM=zcOnyoqvu3GregmW9NS5j9auRuyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Patrick Dung <mpatdung@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 01:20:16PM -0700, Chris Murphy wrote:
> Seen /etc/lvm/lvm.conf issue_discards is probably set to 0.

It should be 0 unless you understand what it's doing and actually want it...

Don't confuse LVM's issue_discards with cryptsetup's allow_discards.

Regards
Andreas Klauer
