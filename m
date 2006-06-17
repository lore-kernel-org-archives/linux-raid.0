From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Sat, 17 Jun 2006 18:01:46 -0400
Message-ID: <44947BCA.9040305@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net> <17556.31295.280083.533342@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17556.31295.280083.533342@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown wrote:
> On Saturday June 17, nigel@nigelterry.net wrote:
>   
>> Any ideas what I should do next? Thanks
>>
>>     
>
> Looks like you've probably hit a bug.  I'll need a bit more info
> though.
>
> First:
>
>   
>> [root@homepc ~]# cat /proc/mdstat
>> Personalities : [raid5] [raid4]
>> md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
>>       490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
>> [UUU_]
>>       [=>...................]  reshape =  6.9% (17073280/245111552) 
>> finish=86.3min speed=44003K/sec
>>
>> unused devices: <none>
>>     
>
> This really makes it look like the reshape is progressing.  How
> long after the reboot was this taken?  How long after hdc1 has hot
> added (roughly)?  What does it show now?
>
> What happens if you remove hdc1 again?  Does the reshape keep going?
>
> What I would expect to happen in this case is that the array reshapes
> into a degraded array, then the missing disk is recovered onto hdc1.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
I don't know how long the system was reshaping before the power went 
off, and then I had to restart when the power came back. It claimed it 
was going to take 430 minutes, so 6% would be about 25 minutes, which 
could make good sense, certainly it looked like it was working fine when 
I went out.

Now nothing is happening, it shows:

[root@homepc ~]# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
      490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
[UUU_]
      [=>...................]  reshape =  6.9% (17073280/245111552) 
finish=2281.2min speed=1665K/sec

unused devices: <none>
[root@homepc ~]#

so the only thing changing is the time till finish.

I'll try removing and adding /dev/hdc1 again. Will it make any 
difference if the device is mounted or not?

Nigel
