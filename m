From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: trouble adding spare
Date: Thu, 22 Jan 2009 18:43:49 +0200
Message-ID: <4978A245.90604@fastmail.co.uk>
References: <496DB3A4.4090605@fastmail.co.uk> <496DE2BD.6070905@fastmail.co.uk>	 <496DE763.9010300@fastmail.co.uk>	 <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan>	 <496DF771.4010407@fastmail.co.uk> <496DFFF0.2060807@fastmail.co.uk>	 <alpine.DEB.1.10.0901141012050.19747@p34.internal.lan>	 <496E26DA.6010703@fastmail.co.uk> <4970CA9C.7060902@fastmail.co.uk>	 <49775980.5010803@fastmail.co.uk> <aebf5d970901211950i7f473a34gbcc78e8736e55856@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970901211950i7f473a34gbcc78e8736e55856@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach wrote:
> On Wed, Jan 21, 2009 at 10:21 AM, Max Waterman
> <davidmaxwaterman@fastmail.co.uk> wrote:
>   
>> Someone else's post prompted me to try :
>>
>> $ sudo /sbin/mdadm --detail --scan
>> ARRAY /dev/md2 level=raid5 num-devices=6 metadata=00.90 spares=2
>> UUID=15bfec75:595ac793:0914f8ee:862effd8
>>
>> and use that in mdadm.conf instead of the output of :
>>
>> ~$ sudo /sbin/mdadm --examine --scan
>> ARRAY /dev/md2 level=raid5 num-devices=6
>> UUID=15bfec75:595ac793:0914f8ee:862effd8
>>  spares=2
>>
>> This fixes my problem of the second spare drive not being added. I'm not
>> sure why.
>>
>> However, mdadm now gives me a 'message' :
>>
>> mdadm: metadata format 00.90 unknown, ignored.
>>
>> What's this about? Anything to worry about?
>>
>>     
>
> Change it to metadata=0.90 instead of metadata=00.90 & it should work
> w/out the error message.  It would probably be good if mdadm.conf
> and/or mdadm --detail --scan dropped leading zeros.
>   
Yup, that fixed the error.

Any ideas why it didn't work with the output of --examine?

Max.
