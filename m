From: Jeff Breidenbach <breidenbach@gmail.com>
Subject: does chunksize matter in raid-1?
Date: Sat, 6 Aug 2005 00:07:48 -0400
Message-ID: <e03b90ae05080521077404ad09@mail.gmail.com>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does chunk size matter *at all* for RAID-1?

mdadm --create /dev/md0 --level=1 --chunk=8 /dev/sdc1 /dev/sdd1   
mdadm --create /dev/md0 --level=1 --chunk=128 /dev/sdc1 /dev/sdd1

In my mental model of how RAID works, it can't possibly matter
what my chunk size is whether I've got 1KB files or 1GB files because
no striped reading occurs. 

Is my mental model wrong?

-Jeff
