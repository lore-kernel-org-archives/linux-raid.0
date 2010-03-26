From: Asdo <asdo@shiftmail.org>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 11:45:29 +0100
Message-ID: <4BAC9049.1010502@shiftmail.org>
References: <4BAB8D41.4010801@gmail.com> <4BAB9703.2050801@shiftmail.org>
 <5bdc1c8b1003251058x1a459118lb29b23eae8cb6d33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5bdc1c8b1003251058x1a459118lb29b23eae8cb6d33@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mark Knecht wrote:
> On Thu, Mar 25, 2010 at 10:01 AM, Asdo <asdo@shiftmail.org> wrote:
>   
>> Might not have ERC / TLER settable, see the other WD drive (WD360GD) here:
>> http://forums.storagereview.com/index.php/topic/28333-tler-cctl/
>> however only 1 WD drive is listed (WD360GD), no info is there specifically
>> on WD20EARS
>>
>> Good luck
>>
>> Update that list if you buy it :-)
>>     
>
> I'm wondering where the guy in the link you provided got the command:
>
> smartctl -l scterc d:
>
> Assuming a Linux shift to
>
> smartctl -l scterc /dev/sda
>
> I get an error message:
>   
The feature will be added in version 5.40. Or get if from SVN
