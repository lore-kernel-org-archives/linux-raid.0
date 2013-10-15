From: Brian Candler <b.candler@pobox.com>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 14:15:18 +0100
Message-ID: <525D3FE6.7000407@pobox.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com> <525C29CD.4080604@pobox.com> <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/10/2013 13:40, peter@steinhoff.se wrote:
>
> Anyway, I'm still at loss what to do and what my next step should be...
>
Well, I'm not the world's authority on this, but from what I can see:

$ egrep '^/|UUID|State :|Events :' ert
/dev/sdd:
             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
            State : clean
           Events : 1288444
/dev/sde:
             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
            State : clean
           Events : 1288428
/dev/sdf:
             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
            State : clean
           Events : 1288444
/dev/sdg:
             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
            State : clean
           Events : 1288444
/dev/sdh:
             UUID : 61a6a879:adb7ac7b:86c7b55e:eb5cc2b6
            State : clean
           Events : 1288444

So it looks like sde is stale with respect to the other drives (which 
have a larger event count) and therefore is not being used. But sdh is a 
spare (you said it was rebuilding onto this?), so you have N-2 usable 
data disks, which is not enough to start RAID5.

DON'T do the following before someone else on the list confirms this is 
the right course of action, but you can force the array to assemble using:

mdadm --stop /dev/mdXXX
mdadm --assemble --force --run /dev/mdXXX /dev/sd{d,e,f,g,h}

But since the state of sde is old, I think there is a real risk that 
data corruption has taken place. Do an fsck before mounting. It may be 
better to restore from a trusted backup.

Regards,

Brian.

