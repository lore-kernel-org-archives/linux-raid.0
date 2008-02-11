From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] Use new sb type
Date: Sun, 10 Feb 2008 22:32:36 -0500
Message-ID: <47AFC1D4.2040605@tmr.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479FB1FB.6040500@tmr.com> <Pine.LNX.4.64.0801292347430.14907@fbirervta.pbzchgretzou.qr> <47AED31A.3070704@dgreaves.com> <Pine.LNX.4.64.0802101311320.7176@fbirervta.pbzchgretzou.qr> <47AEEDAD.5050405@dgreaves.com> <Pine.LNX.4.64.0802101328260.7915@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802101328260.7915@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: David Greaves <david@dgreaves.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On Feb 10 2008 12:27, David Greaves wrote:
>   
>>> I do not see anything wrong by specifying the SB location as a metadata
>>> version. Why should not location be an element of the raid type?
>>> It's fine the way it is IMHO. (Just the default is not :)
>>>       
>> There was quite a discussion about it.
>>
>> For me the main argument is that for most people seeing superblock versions
>> (even the manpage terminology is version and subversion) will correlate
>> incremental versions with improvement.
>> They will therefore see v1.2 as 'the latest and best'.
>> Feel free to argue that the manpage is clear on this - but as we know, not
>> everyone reads the manpages in depth...
>>     
>
> That is indeed suboptimal (but I would not care since I know the
> implications of an SB at the front);
>
> Naming it "1@front" / "1@back" / "1@4K" or so would address this.
>
>   
We have already discussed names and Neil has expressed satisfaction with 
my earlier suggestion. Since "@" is sort of a semi-special character to 
the shell, I suspect we are better off avoiding it.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


