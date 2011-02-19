From: Jon Forrest <jlforrest@berkeley.edu>
Subject: Recovery Optimization?
Date: Fri, 18 Feb 2011 16:06:43 -0800
Message-ID: <ijn1hs$8nl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm just learning how the md system works so what
I'm going to say might not be sensible.

I read that if a disk in a RAID5 set goes bad, and the
disk is replaced by a new one, that the recovery operation
takes place blindly. By this I mean that all the stripes
will be read so that new parity blocks can be written.
But, there might be stripes that contain only blocks
that aren't used by the filesystem. Wouldn't it be
good when doing recovery if some kind of allocation
map were created so that unused stripes wouldn't be
restored. I would think that depending on how full
the disk is that this could save time.

Is this reasonable?

Cordially,
-- 
Jon Forrest
Research Computing Support
College of Chemistry
173 Tan Hall
University of California Berkeley
Berkeley, CA
94720-1460
510-643-1032
jlforrest@berkeley.edu

