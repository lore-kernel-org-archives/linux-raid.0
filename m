From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: scsi card recommendations
Date: Tue, 21 Oct 2003 08:37:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310210837.43091.dusty@strike.wu-wien.ac.at>
References: <200310210040.h9L0eR202908@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310210040.h9L0eR202908@bzs.org>
Content-Disposition: inline
To: michael@insulin-pumpers.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 21 October 2003 03:40, Michael wrote:
> I've just inherited a couple of rack servers that have the buggy dpt
> scsi controllers and I need to replace them with something solid.

Well, I use a dpt SCSI-Controller for some time now and luckily found no bugs 
at all. I always thought they were quite good quality.

> Recommendations for a pci scsi-3 controller would be appreciated.

I used a Mylex DAC960 and was never really fond of it. Maybe the AcceleRAID 
product line is better, but I don't know.

The RAID-company that produces to my mind the best Hardware RAID solutions is 
ICP Vortex. (Maybe they changed names now as they are bought by some bigger 
company). Anyway, they provide excellent quality hardware and write their 
Linux drivers themselves and contribute the code open to the Linux source 
tree.

The downside of ICP Vortex is that they are quite expensive.

Another thing that I would consider is software RAID. Although software RAID 
consumes far more CPU and is probably slower, to my mind the reliability is 
higher. The Linux RAID-code is thouroughly tested and proved to work.

Moreover there is always one thing to consider: If one of your disks fail - no 
problem, you simply replace it with a new one. If the same model isn't 
available anymore, well you just use a better one.
But what happens if your  HW-RAID controller dies? After 2 years, will there 
still be a replacement available? If not, can you reconstruct your data with 
a different controller? Are there any good Linux drivers for this replacement 
controller?
What happens if there is a firmware bug? With Linux SW-RAID you can post to 
this list and the problem will probably be solved. 

I think if the real issue is data security and availability and not speed, 
SW-RAID is at least something to be considered.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

