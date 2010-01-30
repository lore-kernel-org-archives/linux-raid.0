From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then	disaster
 !!
Date: Sat, 30 Jan 2010 16:52:29 +0100
Message-ID: <4B6455BD.5090504@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B633391.3020905@texsoft.it> <20100130075805.GB15471@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100130075805.GB15471@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> Into a previous post I suggested to let at least the admins to be 
>> conscious of the sistuation:
>>
>> I think it's also a mess for the image of the whole linux server 
>> community: try to explain to a customer that his robust raid system, 
>> with 6 disks plus 2 hot spares, just died because there were read 
>> errors, which were well kwnown by the system; and that now all his 
>> valuable data are lost!!! That customer may say "What a 
>> server...!!!", kill you, then get a win server by sure!!
>
> Oh, please, stop trolling.
>

Ok, maybe I'm a bit nervous due to the data loss... touche'
But the problem exists, and it's not only mine: I just see another post 
sent today on similar problem. So it's worth discuss on it, imho, 
because it may involve many installations.

Suppose you have a single disc: if it gives a read error, you lose some 
data and then? Do you keep the disc or do you replace it as soon as 
possible? I guess the second. So I would adopt the same policy if the 
drive is into a raid array too, moreover as one would excpect from it 
the maximun safety. To kick the disk out from the array at the first 
read error is not a good choice too, I agree, as the array can still 
run, BUT the urgency of replacing the disk is the same as for a faulty 
disk, as the array may not survive another disk failure! This should be 
clearly exposed to admin.

I already posted a little path for /proc/mdadm.
I'll try to write a little daemon to track /sys/block/mdXX/rdYY/errors.

Giovanni

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


