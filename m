From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: RAID1 assembled broken array
Date: Thu, 17 Sep 2009 17:09:37 +0000
Message-ID: <1253207377.9662.551.camel@kiste>
References: <h8ophd$n8p$6@ger.gmane.org>
	 <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
	 <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
	 <1253076634.7071.5.camel@kiste>
	 <F52A8F4D-66B0-4F97-B2C9-6FF207817718@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F52A8F4D-66B0-4F97-B2C9-6FF207817718@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2009-09-17 at 12:44 -0400, Doug Ledford wrote:
> >> 1.0 also protects from this problem.
> >
> > So what's the best way to update a 0.9 superblock to 1.0 format?
> >
> > mdadm --assemble --metadata=1.0 --update=summaries ... ?
> 
> I don't think you can.  You just have to create a new array with the  
> new superblock.
> 
Hmm. Looks like you're right.

Consider this to be a feature request, then. If 1.0 is more reasonable
than 0.9, there should be a "safe" upgrade path.

