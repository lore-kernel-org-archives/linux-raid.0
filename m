From: forumscollective@gmail.com
Subject: Re: Understanding raid array status: Active vs Clean
Date: Thu, 29 May 2014 07:52:02 +0200
Message-ID: <1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com> <20140529151658.3bfc97e5@notabene.brown>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140529151658.3bfc97e5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I doubt there is a difference between Ubuntu and Arch here.
> 
> The array should show "active" in "mdadm --detail" output for 200ms after the
> last write, and then switch to 'clean'.
> So if you are writing every 100ms, it will always say "active".
> 
> NeilBrown

For some reason this array has never shown Clean status, only Active.

It isn't written to other than when NFS mounted for adding new content.

Any idea what would cause constant writing - I presume from what I see that the initial array sync completed?