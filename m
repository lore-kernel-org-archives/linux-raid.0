From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Strange error with raid array
Date: Wed, 7 Apr 2004 10:56:22 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16499.20918.804696.848253@cse.unsw.edu.au>
References: <4071A1CC.5030805@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Geir  =?ISO-8859-1?Q?=20R=E5ness?= on Monday April 5
To: =?ISO-8859-1?Q?Geir_R=E5ness?= <post@pulz.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 5, post@pulz.no wrote:
> Hi
> 
> I got 2 raid arrays, both raid0.
> For some weeks the raid array md0 have had errors, indicating one of the 
> disks where gonna die, so i jused the array as an temp partition untill 
> the array died.
snip

> 
> So i realy need an suggestion whats wrong with md1, and how i can fix it
> 

Hard to know without more details.
First: give up on raidstart.
Second: get mdadm, run
   mdadm -E /dev/hde
   mdadm -E /dev/hdf
   mdadm -E /dev/hdg
   mdadm -E /dev/hdh

and show us the result.
Third: try starting with
   mdadm -A /dev/md0 /dev/hde /dev/hdh
   mdadm -A /dev/md0 /dev/hdf /dev/hdg

NeilBrown
