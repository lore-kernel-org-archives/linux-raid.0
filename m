From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
 [xfs]
Date: Thu, 11 Dec 2008 04:24:58 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812110422380.14590@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <49405CD5.4070704@tmr.com> <alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Thu, 11 Dec 2008, Justin Piszcz wrote:

>
>
> On Wed, 10 Dec 2008, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>> Someone should write a document with XFS and barrier support, if I recall,
>
>

Best not to do things in a rush, here is the correct benchmark:

# rm -rf linux*7
# sync
# echo 1 > /proc/sys/vm/drop_caches
# /usr/bin/time bash -c 'tar xf linux-2.6.27.7.tar; sync'
0.13user 1.62system 0:46.67elapsed 3%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (17major+955minor)pagefaults 0swaps

Justin.

