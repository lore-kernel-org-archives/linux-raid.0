From: Scott Sinno <sinno@sinno.net>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 11:43:23 -0400
Message-ID: <5512D79B.704@sinno.net>
References: <5512D21E.1010506@sinno.net> <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se> <5512D3AA.5000003@sinno.net> <alpine.DEB.2.02.1503251628120.20507@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1503251628120.20507@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> Ok, next thing to recommend would be to get the latest mdadm from Niels
> git repo and try with that one. I know some who have fixed similar
> problems to yours by doing this.
> 
> "git clone git://neil.brown.name/mdadm mdadm" and compile that and see
> if --assemble --force works.
> 

That constitutes a huge step forward.  Was able to assemble the array
with all 12 drives using this binary!  Thanks so much!!!

However, after stopping and re-assembling the array, using the 'stock'
CentOS version, it yields this complaint unless '--force' is also used.
 I'm inclined to believe I should simply fail /dev/sdbt and move on, yes?



[root@dsfs01 ~/mdadm]./mdadm -A /dev/md10
mdadm: ignoring /dev/sdbk as it reports /dev/sdbt as failed
mdadm: ignoring /dev/sdbl as it reports /dev/sdbt as failed
mdadm: ignoring /dev/sdbm as it reports /dev/sdbt as failed
mdadm: /dev/md10 assembled from 9 drives - not enough to start the array.
[root@dsfs01 ~/mdadm]mdadm
[root@dsfs01 ~/mdadm]./mdadm -A --force /dev/md10
mdadm: /dev/md10 has been started with 12 drives.
[root@dsfs01 ~/mdadm]mdadm -S /dev/md10
mdadm: stopped /dev/md10
[root@dsfs01 ~/mdadm]mdadm -A /dev/md10
mdadm: ignoring /dev/sdbk as it reports /dev/sdbt as failed
mdadm: ignoring /dev/sdbl as it reports /dev/sdbt as failed
mdadm: ignoring /dev/sdbm as it reports /dev/sdbt as failed
mdadm: /dev/md10 assembled from 9 drives - not enough to start the array.
[root@dsfs01 ~/mdadm]mdadm -A --force /dev/md10
mdadm: /dev/md10 has been started with 12 drives.

