From: David Greaves <david@dgreaves.com>
Subject: Re: Help recreating a raid5
Date: Mon, 03 Apr 2006 07:34:46 +0100
Message-ID: <4430C206.7070606@dgreaves.com>
References: <442F8817.508@dgreaves.com> <17456.33425.813324.99020@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17456.33425.813324.99020@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Sunday April 2, david@dgreaves.com wrote:
>  
>
>>>From some archive reading I understand that I can recreate the array using
>>
>>   mdadm --create /dev/md1 -l5 -n3 /dev/sdd1 /dev/sdb1 missing
>>
>>but that I need to specify the correct order for the drives.
>>
>>I've not used --assume-clean, --force or --run; should I? I assume that
>>since it's only got 2 of 3 then it won't need the assume-clean.
>>
>>The detail and dmesg data suggests that the order in the command  above
>>is correct.
>>
>>Can anyone confirm this?
>>    
>>
>
>Yes, that all looks correct.
>  
>
Thanks Neil

That seemed to work.
Now I need to find out if I have bad hardware or if there is something
(else) wrong with libata :)

David

