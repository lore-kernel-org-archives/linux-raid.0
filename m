From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 17:08:58 -0400
Message-ID: <4AD63DEA.8090906@tmr.com>
References: <hb1udb$6t1$1@ger.gmane.org> <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com> <hb2470$rol$1@ger.gmane.org> <70ed7c3e0910130810r58ab391id2fbfdff6200dcd8@mail.gmail.com> <hb3qpa$6ep$1@ger.gmane.org> <70ed7c3e0910132340q1c4acdfbxa6938261088acca3@mail.gmail.com> <hb4hjp$cg8$1@ger.gmane.org> <70ed7c3e0910140641x74c12a75k6f00df2ed3cbade0@mail.gmail.com> <hb4olr$6to$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hb4olr$6to$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Antonio Perez wrote:
> Majed B. wrote:
>
>   
>> Your applications can request as much files as they want regardless of
>> their location, but the mechanical heads move together, so they can be
>> at a single location at a point of time reading a single stream of a
>> file (or multiple files if they were next to each other on the
>> physical platter).
>>     
>
> Yes that's completely correct, and it's the job of the "elevator" (*) on the 
> "md" code to decide which sector, and in what order, such sectors will be 
> serviced. If the "elevator" is aware of the underlying hardware, it will do 
> the right thing if there are several md or just one.
>
>   
The elevator is part of disk access, not md. It schedules head motion 
for all users of the drive.

> *(I am not an expert on this, is just what I got from Robin)
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

