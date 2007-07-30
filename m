From: "Tomas France" <tomfra@centrum.cz>
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?
Date: Mon, 30 Jul 2007 13:51:03 +0200
Message-ID: <0e5701c7d2a0$0ad0b9c0$332317ac@Cortex>
References: <loom.20070727T225545-192@post.gmane.org><46ABAC5A.2000103@ziu.info><46ABB830.1000204@ziu.info><0dc901c7d20b$be23d100$332317ac@Cortex><18093.42484.733479.935581@notabene.brown><0e3e01c7d293$d85086d0$332317ac@Cortex> <18093.50791.844421.294015@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oops... my faul Neil, sorry for that. I must have been reading the man page 
for an older version. It's all well documented in 2.6.2. I apologize 
again...

Tomas

P.S. And I almost forgot - thanks for creating mdadm! It's a powerful stuff 
for sure. I will soon be playing with it in a live environment...which, 
looking at all the options and reading the documentation, makes me somewhat 
scared :)


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "Tomas France" <tomfra@centrum.cz>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, July 30, 2007 1:07 PM
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?


> On Monday July 30, tomfra@centrum.cz wrote:
>> Thanks for the answer Neil!
>>
>> >> The man page for mdadm does not mention it because it is not 
>> >> supported.
>> >> <<
>>
>> It doesn't actually even mention the possibility to create a RAID-10 
>> array
>> (without creating RAID-0 on top of RAID-1 pairs), yet from the info I 
>> found,
>> a lot of people have been using it for quite a while. Almost as if it was 
>> a
>> complete secret ;) As for the RAID-10 growing / layout change - I'd
>> absolutely love to see that implemented in the (hopefully near) future.
>> IMHO, RAID-10 is becoming very popular because of the falling hard drive
>> prices.
>
> What version of mdadm do you have installed (the bottom of the man
> page will tell you).
> My v2.6.2 manpage mentions raid10 5 times, and "man md" mentions it 9
> times.
> If you have a recent mdadm and there was some particular place in the
> man page were you were looking and didn't find raid10, please let me
> know and I will try to improve that part of the documentation.
>
> Thanks,
> NeilBrown
>
> 

