From: Gilberto Diaz <gilberto@ula.ve>
Subject: Re: cpu consumption
Date: Tue, 24 Jan 2006 08:13:18 -0400
Message-ID: <43D619DE.7010900@ula.ve>
References: <43D55876.5020800@ula.ve> <Pine.LNX.4.56.0601232238440.23760@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601232238440.23760@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Gordon, Guy, Michel and Neil, your advises were very useful.

    Gordon was right, all raids are still syncing (Bellow part of the
/proc/mdstat file).  Guy you were right too, the command "uptime" does
not display the cpu load directly, sorry about that.


Best regards
Gilberto

----------------------------------------------------------------------------------------------------------------------------------------------------
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
[raid10] [faulty]
 
md6 : active raid1 sdk[0] sdl[1]
      244190144 blocks [2/2] [UU]
      [================>....]  resync = 83.4% (203849152/244190144)
finish=5.0min spee
d=131933K/sec
     
md5 : active raid1 sdi[0] sdj[1]
      244190144 blocks [2/2] [UU]
      [================>....]  resync = 83.8% (204684480/244190144)
finish=5.1min spee
d=127124K/sec
     
.
.
.

--------------------------------------------------------------------------------------------------------------------------------------------------------------


Gordon Henderson wrote:

>On Mon, 23 Jan 2006, Gilberto Diaz wrote:
>
>  
>
>>   The problem is that the following proccesses are using a lot of cpu
>>time.
>>
>>    md1_raid1
>>    md1_resync
>>    ......
>>    md6_raid1
>>    md6_resync
>>
>>    Here is a sample of the uptime command
>>
>>17:54:16 up  5:48,  2 users,  load average: 5.02, 5.05, 5.26
>>
>>    Does anybody have an idea what is the problem? Thank a lot in advance
>>    
>>
>
>to me, it looks like the "problem" is that the RAID system is still
>creating the array and syncing all the partitions up. Once it's finished
>your system will be idle.
>
>I bet it's stopped doing it by the time you get this email... What does
>the output of
>
>  cat /proc/mdstat
>
>look like?
>
>Gordon
>
>  
>
