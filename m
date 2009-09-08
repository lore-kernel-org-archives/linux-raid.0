From: "Majed B." <majedb@gmail.com>
Subject: Re: Adaptec 1430SA
Date: Wed, 9 Sep 2009 01:13:01 +0300
Message-ID: <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
References: <769530.6689.qm@web51307.mail.re2.yahoo.com> <4AA67ACF.2080506@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AA67ACF.2080506@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Check this link out:
http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/

AT the end, they have a list of components, cheap ones. One is a
2-port sata card and another is a 4-port sata card. You might find
them appealing to your usage.

On Tue, Sep 8, 2009 at 6:39 PM, John
Robinson<john.robinson@anonymous.org.uk> wrote:
> On 08/09/2009 15:34, Jon Hardcastle wrote:
>>
>> --- On Tue, 8/9/09, Majed B. <majedb@gmail.com> wrote:
>>>
>>> Jon, According to this link (
>>>
>>> http://groups.google.com/group/linux.debian.ports.x86-64/browse_thread/thread/12f2084ceace4c08?pli=1
>>> ) that card uses fake raid
>
> [...]
>>
>> Hi, thanks for the link! I was planning on just using it as a means to get
>> more ports - and then use mdadm to actually to the raid part.
>
> Been doing a spot of Googling around this myself. Looks like there's open
> source code available to support seeing the discs, either with sata_mv or
> Adaptec's own aar81xx drivers, which will get you going for what you say
> above. However, if you did want to use HostRAID (Adaptec's name for
> fakeraid) you either have to build Adaptec's driver linking in their
> closed-source binary HostRAID code or use the open source dmraid.
>
> I'm a bit mystified at the idea of Adaptec using Marvell chips, though. I
> wonder what that's all about?
>
> Cheers,
>
> John.
>



-- 
       Majed B.
