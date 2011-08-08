From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all
 drives "non-fresh"
Date: Sun, 07 Aug 2011 22:55:21 -0700
Message-ID: <4E3F7A49.9000803@aeoncomputing.com>
References: <4E3F4BD0.5060807@aeoncomputing.com> <20110808125608.7ceeaa02@notabene.brown> <4E3F66F2.3030300@aeoncomputing.com> <4E3F68CB.4060005@gmail.com> <4E3F6C07.8040106@aeoncomputing.com> <4E3F6E4D.1010502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3F6E4D.1010502@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joe / et-al,

The '--assemble --update=uuid' appears to have done the trick. It is 
weird because the uuid in the config file matched the uuid of the raid 
volume shown with 'mdadm -D /dev/md3' and the uuid on each of the drives 
shown with 'mdadm -E /dev/sdc1'

The '--update=summaries' did not work. Assigning a new random uuid 
appears to have repaired whatever bit in the superblock was mucked up.

Strange...

Joe, thanks for your help. Find me at SC11, I'm buying you beers.

--Jeff



On 8/7/11 10:04 PM, Joe Landman wrote:
>> Maybe '--update=uuid' ??
>
>
> It looks like it correctly finds /dev/sd[c-z]1 as elements of /dev/md3
>
> Which mdadm are you using?
>
>     mdadm -V
>
> and which kernel?
>
> Try the UUID update, and let us know if it helps.  Also if your mdadm 
> is old (2.6.x), try updating to 3.1.x.
>
> FWIW: we've found problems in the past with Centos 5.4 to 5.5 kernels 
> with MD arrays.  Often times our only real solution would be to update 
> the full OS on the boot drives.  This is for distro specific kernels. 
> For our kernels, we don't run into this issue.
>
>


-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson "at" aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845

4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

