From: peter@steinhoff.se
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 11:01:07 -0400
Message-ID: <20131015110107.18785v3sbh9fdzoc@phobos.elinuxservers.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
 <525C29CD.4080604@pobox.com>
 <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
 <525D3FE6.7000407@pobox.com>
 <20131015101442.19647jupyxo6848w@phobos.elinuxservers.com>
 <525D4F2E.50604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525D4F2E.50604@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <b.candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> But has the new sdh been rebuilt completely? If that case there  
>> should be n-1 drives? Or does "spare" just means that it can be  
>> used but has no data yet?
>>
> That's what I'm not sure about. It is "clean" but it is also  
> "spare". I'm not sure what state would be seen while it is rebuilding.
>
> When the old sdh had a problem, did you mdadm /dev/mdXXX --fail /dev/sdh?
>

No, I didn't think I needed to do that. I just powered down the  
machine and took it out.

> And after you inserted the new drive, and presumably did mdadm  
> /dev/mdXXX --add /dev/sdh, did you see it start to rebuild in  
> /proc/mdstat?
>

Yes I did. It was around 20% or so when I left it.


>> Also I have my old sdh with data on it but I don't know how current  
>> that data is but perhaps I can use that somehow?
>>
> You could mdadm --examine it, but I suspect that the event count  
> will be way out of line by now.
>

I will put it in and see what it shows. Is it correct to assume that  
--examine reads the superblock and I can insert the drive into any  
machine and examine it there?

Thanks,
Peter



