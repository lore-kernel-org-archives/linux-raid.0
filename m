From: Brian Candler <b.candler@pobox.com>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 15:20:30 +0100
Message-ID: <525D4F2E.50604@pobox.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com> <525C29CD.4080604@pobox.com> <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com> <525D3FE6.7000407@pobox.com> <20131015101442.19647jupyxo6848w@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131015101442.19647jupyxo6848w@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/10/2013 15:14, peter@steinhoff.se wrote:
> Thanks Brian.
>
> Yes, I replaced sdh because it showed read errors in dmesg and was 
> kicked out of the array.
>
> But has the new sdh been rebuilt completely? If that case there should 
> be n-1 drives? Or does "spare" just means that it can be used but has 
> no data yet?
>
That's what I'm not sure about. It is "clean" but it is also "spare". 
I'm not sure what state would be seen while it is rebuilding.

When the old sdh had a problem, did you mdadm /dev/mdXXX --fail /dev/sdh?

And after you inserted the new drive, and presumably did mdadm 
/dev/mdXXX --add /dev/sdh, did you see it start to rebuild in /proc/mdstat?

> Also I have my old sdh with data on it but I don't know how current 
> that data is but perhaps I can use that somehow?
>
You could mdadm --examine it, but I suspect that the event count will be 
way out of line by now.

