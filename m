From: peter@steinhoff.se
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Thu, 17 Oct 2013 22:41:42 -0400
Message-ID: <20131017224142.20057jll0sculs4k@phobos.elinuxservers.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
 <20131016171157.7655fe31@notabene.brown>
 <20131016222754.15765kbm152z5skc@phobos.elinuxservers.com>
 <20131017133936.7028c02f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131017133936.7028c02f@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a lot Neil and also big thanks to Brian.

With your help I've have now successfully rebuilt the array. When I  
get the drives RMA'd and get new drives back I'll add those to the  
array and turn it into a raid 6.

Thanks again,
Peter


Quoting NeilBrown <neilb@suse.de>:
> On Wed, 16 Oct 2013 22:27:54 -0400 peter@steinhoff.se wrote:
>> I was just wondering but since I lost 4kB of data when I cloned sdd,
>> does that mean that I will have 4x4kB of garbled data somewhere since
>> I assembled 4 drives (n-1) and the raid system wouldn't know? Or would
>> that have been detected somehow when I ran fsck (ext3)?
>
> You could have 2*4kB of garbled data (the block you lost, and the
> corresponding block on the device that was rebuilt).
> Or you could have 1*4kB, or 0*4kB garbled if either the corrupted block or
> the recovered block were parity blocks.
>
> Those bad blocks are not likely in filesystem metadata else fsck should have
> noticed.  They could be in some file(s), or in some free space - in which
> case you'll never notice.
>
> NeilBrown
>



