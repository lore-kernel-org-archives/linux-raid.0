From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: striping and mirroring with only two disks
Date: Sat, 31 Jan 2004 20:53:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040131195302.GA18341@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Is it possible to both do striping and mirroring if you only have 2 disks?

I was thinking of having the chunks organized on each disk so
that striping reads and writes could be done. Eg. by having 

disk1: chunk0 chunk2 chunk4 ......   chunk1 chunk3 chunk5
disk2: chunk1 chunk3 chunk5 ......   chunk0 chunk2 chunk4

Would such a layout of chunks allow for striped reading and writing?

Best regards
keld
