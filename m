From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 15:47:04 -0600
Message-ID: <4D5D9758.2080400@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5D017B.50109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D017B.50109@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 2/17/2011 5:07 AM:
> On 14/02/2011 23:59, Matt Garman wrote:
> [...]
>> The requirement is basically this: around 40 to 50 compute machines
>> act as basically an ad-hoc scientific compute/simulation/analysis
>> cluster.  These machines all need access to a shared 20 TB pool of
>> storage.  Each compute machine has a gigabit network connection, and
>> it's possible that nearly every machine could simultaneously try to
>> access a large (100 to 1000 MB) file in the storage pool.  In other
>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
> 
> I'd recommend you analyse that requirement more closely. Yes, you have
> 50 compute machines with GigE connections so it's possible they could
> all demand data from the file store at once, but in actual use, would they?

This is a very good point and one which I somewhat ignored in my initial
response, making a silent assumption.  I did so based on personal
experience, and knowledge of what other sites are deploying.

You don't see many deployed filers on the planet with 5 * 10 GbE front
end connections.  In fact, today, you still don't see many deployed
filers with even one 10 GbE front end connection, but usually multiple
(often but not always bonded) GbE connections.

A single 10 GbE front end connection provides a truly enormous amount of
real world bandwidth, over 1 GB/s aggregate sustained.  *This is
equivalent to transferring a full length dual layer DVD in 10 seconds*

Few sites/applications actually need this kind of bandwidth, either
burst or sustained.  But, this is the system I spec'd for the OP
earlier.  Sometimes people get caught up in comparing raw bandwidth
numbers between different platforms and lose sight of the real world
performance they can get from any one of them.

-- 
Stan
