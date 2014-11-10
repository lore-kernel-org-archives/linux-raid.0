From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: md with shared disks
Date: Mon, 10 Nov 2014 17:40:19 +0100
Message-ID: <5460EA73.4080009@shiftmail.org>
References: <545F2630.8090307@true.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545F2630.8090307@true.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/11/2014 09:30, Anton Ekermans wrote:
> Good day raiders,
> I have a question on md that I cannot find (up to date) answer to.
> We use SuperMicro server with 16 shared disks on a shared backplane 
> between two motherboards, running up to date CentOS7.
> If I create an array on one node, the other node can detect it. I put 
> GFS2 on top of the array so both system can share the filesystem, but 
> I want to know if md raid is safe to be used in this way with possibly 
> 2 active/active nodes changing the metadata at the same time. I've 
> disabled raid-check cron job on one node so they don't both resync the 
> drives weekly, but I suspect there's a lot more to it than that.
>
> If it's not possible, then alternatively some advice on strategy to 
> have a large active/active shared disk/filesystem would also be welcome.

Not possible, as far as I know: MD does not reload / exchange metadata 
information with other MD peers. MD thinks it is the only user of those 
disks.
If you attempt to share the arrays and then one head fails one disk and 
starts reconstruction onto another disk, while the other head thinks the 
array is all right, havoc will arise certainly.

Even without this worst-case scenario, data probably will be still lost 
because the two MDs are not cache coherent, so writes on one head will 
not invalidate the kernel cache for the same region on the other head, 
and this is bad because reads performed on the other head will not see 
the changes just written if such area was cached in the kernel.
GFS actually will attempt to invalidate such cache but I am not sure to 
what extent: if you use raid5/6 probably it is not enough because the 
stripe-cache will hold stale data in a way that GFS probably does not 
know about (does not go away even with echo 3 > /proc/sys/vm/drop_caches 
). Maybe raid0/1/10 can be safer... anybody knows if cache dropping 
works well there?
But the problem of consistent vision of disk failures and raid 
reconstruction seems harder to overcome.

You can do an active/passive configuration, shutting down MD on one head 
and starting it on the other head.
Another option is the crossed-active or whatever it is called: some 
arrays are active on one head node, other arrays on the other head node, 
so to share the computational and bandwidth burden.

If other people have better ideas I am all ears.

Regards
EW

