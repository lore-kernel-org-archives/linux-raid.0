From: Phil Turmel <philip@turmel.org>
Subject: Re: kernel refuses devices mdadm -E accepts
Date: Tue, 20 Jan 2015 13:32:10 -0500
Message-ID: <54BE9F2A.9090102@turmel.org>
References: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com> <54BE9E47.9030706@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54BE9E47.9030706@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Wesley W. Terpstra" <wesley@terpstra.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Woops!

On 01/20/2015 01:28 PM, Phil Turmel wrote:
> Hi Wesley,
> 
> On 01/19/2015 06:01 PM, Wesley W. Terpstra wrote:
> 
>> I was in the middle of a reshape of this 4-disk raid5 when something
>> rebooted the computer. The system seems otherwise fine, and I suspect
>> someone in the house.
>>
>> What is the correct next step? Should I try --run ? I would obviously
>> prefer not to lose the data on this array. I expect that the reshape
>> was NOT complete, so just recreating the array will probably corrupt
>> its contents.
>>
>> Kernel version 3.17.8 and mdadm version 3.3.2.
> 
> There have been many bug fixes to mdadm since that kernel was retired.
> You should temporarily boot a current liveCD (my favorite is
> systemrescuecd) and do "mdadm -Afv /dev/mdX /dev/sdX ..."

I misread that kernel version.  It's relatively current.  Hmmm.

I'd still try a liveCD with 3.18.x or 3.19.

> Show us the output of that if it doesn't work (it should resume your
> reshape).

This still holds. :-)

Phil

