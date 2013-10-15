From: Brian Candler <b.candler@pobox.com>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 16:04:15 +0100
Message-ID: <525D596F.4090907@pobox.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com> <525C29CD.4080604@pobox.com> <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com> <525D3FE6.7000407@pobox.com> <20131015101442.19647jupyxo6848w@phobos.elinuxservers.com> <525D4F2E.50604@pobox.com> <20131015110107.18785v3sbh9fdzoc@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131015110107.18785v3sbh9fdzoc@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/10/2013 16:01, peter@steinhoff.se wrote:
>>>
>>> Also I have my old sdh with data on it but I don't know how current 
>>> that data is but perhaps I can use that somehow?
>>>
>> You could mdadm --examine it, but I suspect that the event count will 
>> be way out of line by now.
>>
>
> I will put it in and see what it shows. Is it correct to assume that 
> --examine reads the superblock and I can insert the drive into any 
> machine and examine it there?
>
Yes and yes.

