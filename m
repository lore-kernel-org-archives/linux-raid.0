From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Rotating RAID 1
Date: Fri, 09 Sep 2011 18:28:56 -0400
Message-ID: <4E6A9328.6070801@tmr.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>	<4E497FB5.3030109@ivitera.com>	<CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>	<4E49849E.4030604@ivitera.com>	<20110816084251.2d8e7831@notabene.brown>	<CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com> <20110816095517.757afc07@notabene.brown> <4E4A0F86.6010907@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4A0F86.6010907@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: NeilBrown <neilb@suse.de>, =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Pavel Hofman wrote:
> Dne 16.8.2011 01:55, NeilBrown napsal(a):
>    
>>   Also, it doesn't have to be a linear stack.  It could be a binary tree
>>   though that might take a little more care to construct.
>>      
> Since our backup server being a critical resource needs redundancy
> itself, we are running two degraded RAID1s in parallel, using two
> internal drives. The two alternating external drives plug into the
> corresponding bitmap-enabled RAID1.
>    

I wonder if you could use a four device raid1 here, two drives 
permanently installed and two being added one at a time to the array. 
That gives you internal redundancy and recent backups as well.

I'm still a bit puzzled about the idea of rsync being too much CPU 
overhead, but I'll pass on that. The issue I have had with raid1 for a 
backup is that the data isn't always in a logical useful state when you 
do physical backup. Do thing with scripts and hope you always run the 
right one.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



