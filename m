From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Logging-Loop when a drive in a raid1 fails.
Date: Mon, 13 Dec 2004 10:07:53 -0500
Message-ID: <41BDB049.6060201@steeleye.com>
References: <41BD2E02.8020100@geizhals.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BD2E02.8020100@geizhals.at>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Renner <michael.renner@geizhals.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Renner wrote:

> one of the drives in a software raid1 failed, on a machine running 
> 2.6.9-rc2, leading to this "logging-spree" (see attachment).

> Sorry if this has been fixed in the meanwhile; it's not that easy to 

It has. I sent the patch to Neil Brown a while back to fix this problem. 
I believe it made 2.6.9.

> test codepaths for failing drives with various kernels without having 
> access to special block devices which support on-demand-failing.

mdadm -f /dev/md0 <drive>

roughly approximates a drive failure

> Furthermore I'm a bit concerned about the overall quality of the md 
> support in 2.6

I don't think you should be. md in 2.6 (as of 2.6.9 or so) is as stable 
as 2.4, at least according to our stress tests.

--
Paul
