From: Ben Winslow <rain@bluecherry.net>
Subject: Autostarting arrays with V1 metadata
Date: Wed, 07 May 2008 14:03:39 -0400
Message-ID: <4821EEFB.1040501@bluecherry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've noticed that (as of 2.6.25, at least) the kernel doesn't autostart 
arrays with V1 metadata.  In autostart_arrays(), md_import_device() is 
called for 0.90 arrays only, and there's currently no sort of 
autodetection of the superblock position for V1 metadata.

Is this simply a matter of the code being unwritten, or are there other 
reasons that V1 arrays aren't autostarted (such as the SB format being 
unfinished)?  My only real motivation to use V1 metadata is the unhashed 
homehost field, which I'll give up if the SB format hasn't stabilized yet.

Thanks,
-- 
Ben Winslow <rain@bluecherry.net>
