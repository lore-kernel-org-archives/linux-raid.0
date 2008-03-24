From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: component growing in raid5
Date: Mon, 24 Mar 2008 08:09:35 +0100
Message-ID: <47E753AF.5050507@rabbit.us>
References: <47E5FFB8.5030903@bteam.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E5FFB8.5030903@bteam.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Nagy Zoltan <kirk@bteam.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nagy Zoltan wrote:
> hi all,
> 
> i've set up a two dimensional array:
>    * leaf nodes composes raid5 arrays from their disks, and export it as 
> a iSCSI target
>    * the root node creates a raid5 on top of the exported targets
> 
> in this setup i will have to face that an array component can(and would) 
> grow, so i
> created a test case for this to see what comes out ;)
>    * after growing the components mdadm won't recognized them anymore as 
> an array member
>        (because there are no superblock at the end of the device - last 
> 64k?)
>       i've tried to inform mdadm about the size of the components, but 
> it sad no ;)
>    * i've added an arbitary superblock copy operation after the 
> expansion, to make possible for
>   mdadm to recognize and assemble the array - it's working, and passes 
> my test.
> 
> is there a less 'funky' solution for this ;)
> can i run into any trouble when doing this on the real system?
> 

I would simply use a v1.1 superblock which will be situated at the start of 
the array. Then you will face another problem - once you grow a leaf device, 
mdadm will not see the new size as it will find the superblock at sect 0 and 
will be done there. You will need to issue mdadm -A ... --update devicesize. 
The rest of the operations are identical.

As a side note I am also curious why do you go the raid55 path (I am not very 
impressed however :)

Peter
