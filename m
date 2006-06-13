From: Adam Talbot <talbotx@comcast.net>
Subject: RAID tuning?
Date: Mon, 12 Jun 2006 18:18:55 -0700
Message-ID: <448E127F.5010708@comcast.net>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com> <17550.2944.728044.154492@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17550.2944.728044.154492@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

RAID tuning?
Just got my new array setup running RAID 6 on 6 disks.  Now I am looking
to tune it.  I am still testing and playing with it, so I dont mind
rebuild the array a few times.

Is chunk size per disk or is it total stripe?  
Will using mkfs.ext3 -b N make a performance difference?
Are there any other things that I should keep in mind?
-Adam
