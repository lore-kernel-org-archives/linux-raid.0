From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Raid1 stalls during hotplug and Promise SATA TX4
Date: Fri, 22 Apr 2005 15:12:24 +0400
Message-ID: <4268DC18.8060205@wasp.net.au>
References: <32973.10.0.0.2.1114128004.squirrel@resen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32973.10.0.0.2.1114128004.squirrel@resen.org>
Sender: linux-raid-owner@vger.kernel.org
To: skrald@amossen.dk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

skrald@amossen.dk wrote:
> Can somebody help me decoding the behavior described below?
> 
> I have just bought a Promise SATA TX4 controler and runs software raid1 on
> it. According to
>    http://linux.yyz.us/sata/sata-status.html#tx2
> libata should support hotplug on this card.
> 
> Now, when I mark all partitions on /dev/sdb as faulty and do a
>    mdadm -r /dev/md0 /dev/sdb*
> the disc disappears from the arrays just fine.
> 
> Now I unplug the disc without shutting down first (I have two icy dock
> MB123 SK docking stations) which should work just fine according to the
> above link.

The short answer is libata does not yet support hotplug.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
