From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: integrity verification on raid-5?
Date: Fri, 17 Dec 2010 14:25:02 -0700
Message-ID: <4D0BD52E.9000905@feystorm.net>
References: <4D0BD140.6040205@feystorm.net> <20101218081745.63b05bc2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101218081745.63b05bc2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Perfect, thank you very much.

Hopefully google indexes the mailing list so this answer will be out 
there now :-)

-Patrick

Sent: Fri Dec 17 2010 14:17:45 GMT-0700 (Mountain Standard Time)
From: Neil Brown <neilb@suse.de>
To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
Subject: Re: integrity verification on raid-5?
> On Fri, 17 Dec 2010 14:08:16 -0700 "Patrick H." <linux-raid@feystorm.net>
> wrote:
>
>   
>> Is there a way to do integrity verification on a raid-5 array? I'm 
>> working on building a storage system on SSDs under raid-5 and want to be 
>> able to perform periodic integrity checks. Basically just check the 
>> drives to make sure that they match what the parity drive has.
>> After a bit of googling I saw other people wanting the same thing but 
>> nobody with any result. I dont see why this cant be done, but is there 
>> any tool to do so?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
>
> % man 4 md
>
> search for 'check'.
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
