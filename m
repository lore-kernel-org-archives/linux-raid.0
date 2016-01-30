From: Sarah Newman <srn@prgmr.com>
Subject: Re: mdadm bad blocks list
Date: Sat, 30 Jan 2016 10:22:11 -0800
Message-ID: <56ACFF53.2020402@prgmr.com>
References: <56A9102D.4030304@prgmr.com>
 <87twly1jc7.fsf@notabene.neil.brown.name> <56A99118.2080508@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A99118.2080508@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/27/2016 07:55 PM, Sarah Newman wrote:
> On 01/27/2016 07:19 PM, NeilBrown wrote:
>> On Thu, Jan 28 2016, Sarah Newman wrote:
>>
>>> I experienced the following problems with the mdadm bad blocks list:
>>>
>>> 1. Additions to the bad block list do not cause an email to be sent by the mdadm monitor. Expected behavior is for an email to be sent as soon as the
>>> bad blocks list becomes non-empty.
>>
>> Yes, that would be a good idea.  If you do develop patches, please post
>> them.
> 
> Will do, but I don't have a definite time frame for it.

Since patches will not immediately propagate, I wrote an ansible role https://github.com/prgmrcom/ansible-role-mdadm-bad-blocks which contains the
script https://github.com/prgmrcom/ansible-role-mdadm-bad-blocks/blob/master/files/usr/local/bin/raid-bad-blocks . Feedback welcome.

