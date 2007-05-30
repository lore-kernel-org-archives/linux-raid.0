From: Nix <nix@esperi.org.uk>
Subject: Re: RAID SB 1.x autodetection
Date: Thu, 31 May 2007 00:01:33 +0100
Message-ID: <87y7j5ud9u.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr>
	<877iqqul7a.fsf@hades.wkstn.nix> <465DE009.7060202@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <465DE009.7060202@tmr.com> (Bill Davidsen's message of "Wed, 30 May 2007 16:35:21 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30 May 2007, Bill Davidsen stated:

> Nix wrote:
>> On 29 May 2007, Jan Engelhardt uttered the following:
>>
>>
>>> from your post at http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07384.html I read that autodetecting arrays with a
>>> 1.x superblock is currently impossible. Does it at least work to force the kernel to always assume a 1.x sb? There are some
>>> 'broken' distros out there that still don't use mdadm in initramfs, and recreating the initramfs each time is a bit cumbersome...
>>
>> The kernel build system should be able to do that for you, shouldn't it?
>>
> That would be an improvement, yes.

Allow me to rephrase: the kernel build system *can* do that for you ;)
that is, it can build a gzipped cpio archive from components located
anywhere on the filesystem or arbitrary source located under usr/.

-- 
`On a scale of one to ten of usefulness, BBC BASIC was several points ahead
 of the competition, scoring a relatively respectable zero.' --- Peter Corlett
