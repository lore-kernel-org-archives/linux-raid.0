From: Luke Sheldrick <luke@sheldrick.co.uk>
Subject: mdadm crashing server?
Date: Mon, 28 Apr 2008 05:30:47 +0100
Message-ID: <00c801c8a8e8$a1dc5670$0405a8c0@hp>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Have a niggling problem on my home nas at the 
moment.

I rebuilt a raid 1 array a few nights ago, and 
haven't managed to get the disc's to resync since 
creating a ext3 fs on the array.

It would seem that as soon as they try to resync 
it crashes the server, totally. All networking 
stops, not responsive at the console.

If I keep the array up with a single disc (doesn't 
matter which) then all is fine.

There is another raid on the server using mdadm 
which runs fine.

Any ideas?

Background:
Server running FC8, up to date on testing tree, 
although same problem on stable.
The two disc's are on the tertiary ide (master, 
slave). Both maxtor 250gb.
Server, Dell Poweredge 600sc.

Thanks


