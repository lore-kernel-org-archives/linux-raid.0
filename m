From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Crashing a software raid 5 partition ( disk trouble )
Date: Thu, 12 Jun 2003 20:29:49 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16104.22045.492729.835610@gargle.gargle.HOWL>
References: <007201c330b9$c316f310$3001a8c0@melkor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nicolas Meaux on Thursday June 12
To: Nicolas Meaux <nicolas.meaux@artabel.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 12, nicolas.meaux@artabel.net wrote:
> Hi,
> 
> I have a big problems with my software RAID partition ( its a RAID 5
> one ).

Get mdadm
Use
   mdadm -A /dev/md2 /dev/sd[a-f]

NeilBrown

http://www.kernel.org/pub/linux/utils/raid/mdadm/

