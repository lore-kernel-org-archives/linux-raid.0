From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 11:07:39 +0000
Message-ID: <4D5D017B.50109@anonymous.org.uk>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/02/2011 23:59, Matt Garman wrote:
[...]
> The requirement is basically this: around 40 to 50 compute machines
> act as basically an ad-hoc scientific compute/simulation/analysis
> cluster.  These machines all need access to a shared 20 TB pool of
> storage.  Each compute machine has a gigabit network connection, and
> it's possible that nearly every machine could simultaneously try to
> access a large (100 to 1000 MB) file in the storage pool.  In other
> words, a 20 TB file store with bandwidth upwards of 50 Gbps.

I'd recommend you analyse that requirement more closely. Yes, you have 
50 compute machines with GigE connections so it's possible they could 
all demand data from the file store at once, but in actual use, would they?

For example, if these machines were each to demand a 100MB file, how 
long would they spend computing their results from it? If it's only 1 
second, then you would indeed need an aggregate bandwidth of 50Gbps[1]. 
If it's 20 seconds processing, your filer only needs an aggregate 
bandwidth of 2.5Gbps.

So I'd recommend you work out first how much data the compute machines 
can actually chew through and work up from there, rather than what their 
network connections could stream through and work down.

Cheers,

John.

[1] I'm assuming the compute nodes are fetching the data for the next 
compute cycle while they're working on this one; if they're not you're 
likely making unnecessary demands on your filer while leaving your 
compute nodes idle.

