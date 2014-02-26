From: Charles Polisher <cpolish@surewest.net>
Subject: Re: Reshape RAID10 -> RAID1
Date: Tue, 25 Feb 2014 23:20:54 -0800
Message-ID: <20140226072054.GE14322@kevin.peecee3.com>
References: <20140226060532.GA18630@kevin.peecee3.com>
 <20140226180317.10790f0e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140226180317.10790f0e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 26, 2014 at 06:03:17PM +1100, NeilBrown wrote:
> On Tue, 25 Feb 2014 22:05:32 -0800 Charles Polisher <cpolish@surewest.net>
> wrote:
> 
> > Hi all,
> > 
> > I hope to reshape a RAID10 (near,2) with 2 failed and physically
> > removed members [_U_U] into a RAID1 hopefully [UU], for the
> > benefit of seeing a healthy status.
> > 
> > Is following proposed invocation correct?
> > 
> >    mdadm --grow /dev/md2 --level=1
> 
> I think so.  If not, mdadm will complain.
> 
> It is quite easy to experiment: create some largish file, use losetup to turn
> them into block device.  Then experiment with /dev/loop*

Thanks! Will do exactly that.
-- 
Charles

