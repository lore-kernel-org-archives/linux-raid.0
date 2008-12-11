From: Brad Campbell <brad@wasp.net.au>
Subject: Basic RAID5/6 reshape question
Date: Thu, 11 Dec 2008 13:55:03 +0400
Message-ID: <4940E377.7070907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I'm just doing some system upgrades and shuffling some arrays around as part of the process.
All my other current questions have been answered by experimentation, but one.

I'm going to start with a RAID 6 comprised of 7 x 1TB drives, and reshaping to 10 x 1TB.
I'm doing an experiment right now with re-shaping a RAID-5 of 2 drives into 3 drives which is taking 
about 20 hours, from that I'm assuming that a nice big re-shape will take a considerable amount of 
time. I have a reliable UPS, I'm more concerned about a drive or cable flaking out.

What happens if I'm in the middle of a reshape of a RAID 5 or 6 and lose a drive?

Will the array be able to continue to reshape in a degraded state?

Hoping of course that this does not occur, but just trying to plan ahead in case.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
