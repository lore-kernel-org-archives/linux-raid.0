From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Adaptec 1430SA
Date: Tue, 08 Sep 2009 16:39:59 +0100
Message-ID: <4AA67ACF.2080506@anonymous.org.uk>
References: <769530.6689.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <769530.6689.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: "Majed B." <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/09/2009 15:34, Jon Hardcastle wrote:
> --- On Tue, 8/9/09, Majed B. <majedb@gmail.com> wrote:
>> Jon, According to this link (
>> http://groups.google.com/group/linux.debian.ports.x86-64/browse_thread/thread/12f2084ceace4c08?pli=1
>> ) that card uses fake raid
[...]
> Hi, thanks for the link! I was planning on just using it as a means to get more ports - and then use mdadm to actually to the raid part.

Been doing a spot of Googling around this myself. Looks like there's 
open source code available to support seeing the discs, either with 
sata_mv or Adaptec's own aar81xx drivers, which will get you going for 
what you say above. However, if you did want to use HostRAID (Adaptec's 
name for fakeraid) you either have to build Adaptec's driver linking in 
their closed-source binary HostRAID code or use the open source dmraid.

I'm a bit mystified at the idea of Adaptec using Marvell chips, though. 
I wonder what that's all about?

Cheers,

John.
