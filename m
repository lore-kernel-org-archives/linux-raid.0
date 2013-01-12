From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 12 Jan 2013 02:33:38 -0600
Message-ID: <50F11FE2.8090701@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301111151.44384.thomas@fjellstrom.ca> <50F08F96.1050909@hardwarefreak.com> <201301111944.33921.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301111944.33921.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/11/2013 8:44 PM, Thomas Fjellstrom wrote:
> On Fri Jan 11, 2013, Stan Hoeppner wrote:
>> On 1/11/2013 12:51 PM, Thomas Fjellstrom wrote:
>>>> It's not but as Stan writes it may not be preferred for your
>>>> application.
>>>
>>> Hm, ok, it is in my mount line, so I'll try it with that off. Though I
>>> would be interested in hearing from Stan why it may not be good.
>>
>> You should not do this.  This parameter is not a toggle switch intended
>> to be flipped on/off at will, but changed only once and left there.
> 
> Makes me wonder why they are mount options if they aren't meant to ever be 
> changed?

I'll answer that question with a question:  If you were to implement a
new (secondary) allocator on a 10 year old filesystem, by what mechanism
would you have the user enable it?

You can't change the allocator while the filesystem is mounted, so you
can't do this with a sysctl.  So if you must remount the filesystem to
enable the new allocator, where do you enable it?

Make sense yet?

>> Never change XFS parameters willy-nilly without knowing the
>> consequences.  And currently you certainly do not know them.
>>
>> I don't have time for the detailed explanation.  Ask on the XFS list.
> 
> Alright, thanks for your help :)

And as the last few times over many months, you never post to the XFS
list.  Which tells me you really don't care to learn this stuff.

-- 
Stan


