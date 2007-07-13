From: Jon Collette <jon@etelos.com>
Subject: Re: mdadm create to existing raid5
Date: Fri, 13 Jul 2007 11:25:20 -0700
Message-ID: <4697C390.8000501@etelos.com>
References: <200707122318.l6CNIao08247@www.watkins-home.com> <469736E2.7040802@dgreaves.com> <469754B0.4020104@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469754B0.4020104@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The mdadm --create with missing instead of a drive is a good idea.  Do 
you actually say missing or just leave out a drive?  However doesn't it 
do a sync everytime you create?  So wouldn't you run the risk of 
corrupting another drive each time?  Or does it not sync because of the 
saying missing?

To bad I am intent on learning things the hard way.

/etc/mdadm.conf from before I recreated
ARRAY /dev/md2 level=raid5 num-devices=4 spares=1 
UUID=4f935928:2b7a1633:71d575d6:dab4d6bc

/etc/mdadm.conf after I recreated
ARRAY /dev/md1 level=raid5 num-devices=4 
UUID=81bdd737:901c0a8f:af38cb94:41c4e3da

Well before I heard back from you guys .  I noticed this problem and in 
my fountain of infinite wisdom I did mdadm --zero-superblock to all my 
raid drives and created them again thinking if I got it to look the same 
it woud just fix it.  Well they do look the same now, I am at work or I 
would give you the new mdadm.conf.

I really need to learn patients :(


David Greaves wrote:
> David Greaves wrote:
>> For a simple 4 device array I there are 24 permutations - doable by 
>> hand, if you have 5 devices then it's 120, 6 is 720 - getting tricky ;)
>
> Oh, wait, for 4 devices there are 24 permutations - and you need to do 
> it 4 times, substituting 'missing' for each device - so 96 trials.
>
> 4320 trials for a 6 device array.
>
> Hmm. I've got a 7 device raid 6 - I think I'll go an make a note of 
> how it's put together... <grin>
>
>
> Have a look at this section and the linked script.
> I can't test it until later
>
> http://linux-raid.osdl.org/index.php/RAID_Recovery
>
> http://linux-raid.osdl.org/index.php/Permute_array.pl
>
>
> David
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

