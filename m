From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Thu, 28 Aug 2014 09:53:53 +0000
Message-ID: <20140828095352.GM11855@bitfolk.com>
References: <20140823163110.GE11855@bitfolk.com>
 <20140824130939.461501b4@notabene.brown>
 <20140824143944.GC19874@bitfolk.com>
 <20140825103234.GH11855@bitfolk.com>
 <20140825212614.5be558c9@notabene.brown>
 <20140825113402.GF19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140825113402.GF19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Any ideas on the below? Not in a huge rush but at some point I might
have to just re-create the array and copy data back.

Cheers,
Andy

On Mon, Aug 25, 2014 at 11:34:03AM +0000, Andy Smith wrote:
> Hi Neil,
> 
> On Mon, Aug 25, 2014 at 09:26:14PM +1000, NeilBrown wrote:
> > What does "mdadm --examine" on one of the devices report now that it is v1.0?
> > 
> > Particularly interested in the "Unused Space :" line.
> 
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 3905b303:ca604b72:be5949c4:ab051b7a
>            Name : 2
>   Creation Time : Sun Jun  4 08:18:59 2006
>      Raid Level : raid10
>    Raid Devices : 6
> 
>  Avail Dev Size : 618726528 (295.03 GiB 316.79 GB)
>      Array Size : 928089792 (885.10 GiB 950.36 GB)
>    Super Offset : 618727392 sectors
>    Unused Space : before=0 sectors, after=864 sectors
>           State : active
>     Device UUID : e30176be:81a57e84:1f2aa206:9515150f
> 
>     Update Time : Sun Aug 24 14:29:15 2014
>        Checksum : bd599c72 - correct
>          Events : 1
> 
>          Layout : near=2
>      Chunk Size : 64K
> 
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> All other devices report same (apart from UUID/checksum/role).
