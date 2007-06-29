From: David Greaves <david@dgreaves.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 14:30:19 +0100
Message-ID: <4685096B.9000400@dgreaves.com>
References: <46744065.6060605@dgreaves.com> <20070629074322.GT31489@sgi.com> <4684BAA4.4010905@dgreaves.com> <200706291518.18072.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706291518.18072.rjw@sisk.pl>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Pavel Machek <pavel@ucw.cz>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
List-Id: linux-raid.ids

Rafael J. Wysocki wrote:
> On Friday, 29 June 2007 09:54, David Greaves wrote:
>> David Chinner wrote:
>>> On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
>>>> What happens if a filesystem is frozen and I hibernate?
>>>> Will it be thawed when I resume?
>>> If you froze it yourself, then you'll have to thaw it yourself.
>> So hibernate will not attempt to re-freeze a frozen fs and, during resume, it 
>> will only thaw filesystems that were frozen by the suspend?
> 
> Right now it doesn't freeze (or thaw) any filesystems.  It just sync()s them
> before creating the hibernation image.
Thanks. Yes I realise that :)
I wasn't clear, I should have said:
So hibernate should not attempt to re-freeze a frozen fs and, during resume, it
should only thaw filesystems that were frozen by the suspend.


> However, the fact that you've seen corruption with the XFS filesystems frozen
> before the hibernation indicates that the problem occurs on a lower level.
And that was why I chimed in - I don't think freezing fixes the problem (though 
it may make sense for other reasons).

David


