From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: RAID1 assembled broken array
Date: Wed, 16 Sep 2009 06:50:34 +0200
Message-ID: <1253076634.7071.5.camel@kiste>
References: <h8ophd$n8p$6@ger.gmane.org>
	 <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
	 <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-09-16 at 07:01 +1000, NeilBrown wrote:
> 1.0 also protects from this problem.

So what's the best way to update a 0.9 superblock to 1.0 format?

mdadm --assemble --metadata=1.0 --update=summaries ... ?

