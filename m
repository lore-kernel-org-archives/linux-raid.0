From: Neil Brown <neilb@suse.de>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Sat, 6 Mar 2010 07:38:30 +1100
Message-ID: <20100306073830.40f10294@notabene.brown>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	<20100305075016.51e98363@notabene.brown>
	<b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	<20100305123028.55a34c14@notabene.brown>
	<a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
	<4877c76c1003051205i23998a72xc9df3174c1e7fd17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003051205i23998a72xc9df3174c1e7fd17@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Mar 2010 12:05:32 -0800
Michael Evans <mjevans1983@gmail.com> wrote:


> Here's a stab at it. I've never tried to do it like this and haven't
> glanced at the code so I can't be sure, but this seems to be the most
> likely suspect:
> 
> #ARRAY /dev/md0 level=raid5 num-devices=4 devices=sda2,sdb2,sdd2,sdc2
> 
> Your commented out version seems to specify this mapping
> 0,sda2
> 1,sdb2
> 2,sdd2
> 3,sdc2
> 

No it doesn't.  The 'devices=' lists is an unordered list (as set?).  It just
says "only try to include these devices in the array".  They still have to
have valid metadata, and it is the content of the metadata the defines the
role of the device in the array.

NeilBrown
