From: Neil Brown <neilb@suse.de>
Subject: Re: Basic RAID5/6 reshape question
Date: Tue, 16 Dec 2008 09:20:09 +1100
Message-ID: <18758.55321.738370.893867@notabene.brown>
References: <4940E377.7070907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brad Campbell on Thursday December 11
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday December 11, brad@wasp.net.au wrote:
> G'day all,
> 
> I'm just doing some system upgrades and shuffling some arrays around as part of the process.
> All my other current questions have been answered by experimentation, but one.
> 
> I'm going to start with a RAID 6 comprised of 7 x 1TB drives, and reshaping to 10 x 1TB.
> I'm doing an experiment right now with re-shaping a RAID-5 of 2 drives into 3 drives which is taking 
> about 20 hours, from that I'm assuming that a nice big re-shape will take a considerable amount of 
> time. I have a reliable UPS, I'm more concerned about a drive or cable flaking out.
> 
> What happens if I'm in the middle of a reshape of a RAID 5 or 6 and lose a drive?

The reshape continues creating a degraded array.

> 
> Will the array be able to continue to reshape in a degraded state?

Yes.
The process is designed to survive losing a single drive, or a system
crash (but not both).

> 
> Hoping of course that this does not occur, but just trying to plan ahead in case.

Sensible!

NeilBrown
