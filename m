From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Crashing a software raid 5 partition ( disk trouble )
Date: Thu, 12 Jun 2003 20:35:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16104.22361.508001.916567@gargle.gargle.HOWL>
References: <007201c330b9$c316f310$3001a8c0@melkor>
	<16104.22045.492729.835610@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday June 12
To: Nicolas Meaux <nicolas.meaux@artabel.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 12, neilb@cse.unsw.edu.au wrote:
> On Thursday June 12, nicolas.meaux@artabel.net wrote:
> > Hi,
> > 
> > I have a big problems with my software RAID partition ( its a RAID 5
> > one ).
> 
> Get mdadm
> Use
>    mdadm -A /dev/md2 /dev/sd[a-f]

Sorry, forgot the --force:

   mdadm -A --force /dev/md2 /dev/sd[a-f]

NB

> 
> NeilBrown
> 
> http://www.kernel.org/pub/linux/utils/raid/mdadm/
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
