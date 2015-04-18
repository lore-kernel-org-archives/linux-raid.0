From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid 5 rebuild and Raid 6 reshape question
Date: Sat, 18 Apr 2015 15:13:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504181511310.16871@uplift.swm.pp.se>
References: <6744821.j7csV3RJVE@balsa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6744821.j7csV3RJVE@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Apr 2015, Thomas Fjellstrom wrote:

> I had a 5 disk Raid5 with 3TB disks. One disk threw some errors (but still
> seemed to work), and i decided to replace it. I actually bought two drives,

If you have a not-ancient kernel, you should have issued the replace 
command. You should have added one new drive as spare, then (with a new 
mdadm) issued the --replace command. This would have started copying the 
drive you wanted replaced onto the spare. Then after all this was done, 
you could have added another spare and told it to re-shape to raid6. 
That's at least what I would have done.

http://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
