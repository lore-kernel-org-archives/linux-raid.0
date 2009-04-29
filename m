From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID halting
Date: Wed, 29 Apr 2009 12:25:56 +0100
Message-ID: <49F83944.8030302@anonymous.org.uk>
References: <20090428193311920.MKKC6143@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090428193311920.MKKC6143@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/04/2009 20:33, Leslie Rhorer wrote:
[...]
>  Is it possible, then to use the 1T drives
> combined with a like number of 1.5T to create a number (say, 6 or so) of
> 2.5T LVM volumes and then use mdadm to create a RAID 5 array assembled from
> the virtual volumes?

Yes, you could do that, though I think I'd use md to create 6 linear 
sets, which are then combined into a RAID 5; I imagine md will perform 
better than LVM for this task.

What I'd be much more inclined to do is create 2 RAID 5 sets, one of 1T 
discs, and one of 1.5T discs, then combine the two using LVM. It just 
feels more natural to me that way. In addition, while both setups will 
tolerate one disc failure, yours will then only tolerate one particular 
one of the remaining 11 failing (the companion drive in the LVM/linear 
pair), and mine will tolerate a failure of any drive on the other RAID-5.

Hope this is of interest.

Cheers,

John.

