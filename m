From: aristizb@ualberta.ca
Subject: Re: SET_BITMAP_FILE assembling raid1
Date: Fri, 18 Sep 2009 11:35:44 -0600
Message-ID: <20090918113544.11084l0ma4v10u0w@webmail.ualberta.ca>
References: <20090917160718.15831qsk0zd6k2e8@webmail.ualberta.ca>
	<19123.11528.751595.835367@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19123.11528.751595.835367@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

That is exactly the message I get in the kernel logs.

I tried ten times to assemble the array (waiting 2 seconds in between)  
with no luck, but after 2-3 minutes it worked.



Quoting "Neil Brown" <neilb@suse.de>:

> On Thursday September 17, aristizb@ualberta.ca wrote:
>> Hi,
>>
>> After have stopped a raid1, I try to assemble it with one device and
>> its bitmap; but I received the following error message:
>>
>> $mdadm --assemble --force /dev/md2003 --bitmap=/tmp/md2003bm
>> /dev/syntropy21/ian_dvol_200_0_1
>>
>> mdadm: SET_BITMAP_FILE failed.
>>
>> After 5 minutes I retry the command and it succeeds, assembling the
>> raid without any problems.
>>
>>
>> It looks like mdadm cannot use the file I specified for the external
>> bitmap, but this file is not in use by any other raid. Is there any
>> explanation on why assemble could fail to create the raid with the
>> specified bitmap?
>
> If it failed once and then succeeded later it is most like that md
> thought the file was already in use in some way.
>
> If so there should be a message in the kernel logs saying something
> like:
>   md2003: error: bitmap file is already in use
>
> Was there such a message?
>
> NeilBrown
>
>
>>
>>
>> Thank you.
>>
>>
>>
>> Juan.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

