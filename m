From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid 5 and Power Failure
Date: Sat, 13 Jul 2002 10:19:32 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15663.29204.41082.959065@notabene.cse.unsw.edu.au>
References: <200207121622.59345.stclists@wearesimply.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jason Pfingstmann on Friday July 12
To: Jason Pfingstmann <stclists@wearesimply.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 12, stclists@wearesimply.com wrote:
> 
> Now, the event counter for the raid 5 array lists 3 different things - 5 
> drives show event counter to be 00 00 00 38, 1 drive shows 00 00 00 28 (hda), 
> and 1 drive shows 00 00 00 37 (hdd).

Looks like hda has be out-of-it for quite a while... you really need
to monitor raid status somehow.

> Even if hdd is completely bad, I can't afford to lose 250 GB of
> data...

You do have backups of course.... :-)

> 
> Any ideas or suggestions? 

Get mdadm
  http://www.cse.unsw.edu.au/~neilb/source/mdadm/

and use
  mdadm --assemble --force /dev/md0 /dev/hd......

(i.e. after the name of the array, list all the component drives).

NeilBrown
