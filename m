From: stef@chronozon.artofdns.com (Stef Telford)
Subject: Re: 2.5.62 oops and Raid-5
Date: Mon, 17 Feb 2003 19:50:42 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030218005042.130A5469C1@chronozon.artofdns.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au, stef@chronozon.artofdns.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

actually, whilst i was sending you the ksymoops output
i searched and googled a bit and saw that hotplug seems
to crop up more than once in conjunction with the 
worker_thread 'oops'. I disabled that and recompiled 
(its an athlon, so it doesnt take long), re-lilo'd and
booted the 'new kernel'. This was the only kernel parameter
i changed and now i can mount the raid5 and it is marked
'clean' after the rebuild. i am currently using it as
well, playing mp3's from it, so its looking good.

that being said, there -was- a symoops on mount, although
it wasnt enough to stop it from mounting, and it appears
to be the same as the last one (same sort of ksymoops
output :\

i will try the patch tomorrow and let you know, i am
jst glad that the drive is working (for now :)

thanks for the help 
Stef
