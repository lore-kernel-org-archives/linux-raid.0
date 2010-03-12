From: Luca Berra <bluca@comedia.it>
Subject: Re: Growing after replacing with larger discs
Date: Fri, 12 Mar 2010 19:09:10 +0100
Message-ID: <20100312180910.GA12002@maude.comedia.it>
References: <4B9A7C63.6090202@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B9A7C63.6090202@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 12, 2010 at 05:39:47PM +0000, John Robinson wrote:
> Before I have to go to a customer's premises and try it, I wanted to ask if 
> anyone had already done anything like this: I have a CentOS 5 system with 
> 0.90 metadata and type fd partitions with RAID-5 over 3 discs. I want to 
> grow it by replacing the drives. If I dd the small partitions onto larger 
> ones on the new discs, then reboot, will the system recognise the RAID-5 - 
> which now has its metadata somewhere in the middle of the paritions not at 
> the end - so that I can then --grow?
I believe it won't work
mdadm has no way to know where the metadata is in the above case.

you have to follow the painful procedure
fail one drive (mdadm /dev/mdX --fail /dev/sdY)
remove it (mdadm /dev/mdX --remove /dev/sdY)
replace drive with larger one
create larger partition
add drive again (mdadm /dev/mdX --add /dev/sdY)
wait for it to resync...
...and repeat until all drives have been replaced

L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
