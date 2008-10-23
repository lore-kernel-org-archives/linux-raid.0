From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: bad block checking and repair
Date: Thu, 23 Oct 2008 14:31:17 +0200
Message-ID: <20081023123117.GA24775@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a case for better bad block handling in linux raid?

Disk errors are reported to be more and more frequent in today's
systems. Storage capacity grows and with that the likelihood of disk
errors.

I am not sure of the ststus of bad block handling in linux raid.
Can somebody enlighten me?

I think there are a number of techniques that could be employed.

1. checking an array - full scan, and occasionally examining the SMART
error log, eg. every gigabyte, then rewrite the data with reported
errors. Then check the SMART error log again and for the errors still
reported move it to a bad block area and remap the affected data.

2. When irrecoverable errors have occurred, then check which drive was
affected, and remap the bad data on the bad disk, using the data of the
sound drive (for raids with redundant data). 

Is this viable techniques? I think something like this could be built
into the raid check functionality.

best regards
keld
