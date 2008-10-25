From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm degraded RAID5 failure
Date: Sat, 25 Oct 2008 11:44:17 +0100
Message-ID: <4902F881.9080305@dgreaves.com>
References: <6cc8e9ed0810221350o2b8b3aedm3d1c229fe7e66163@mail.gmail.com>	<6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com> <18690.48372.369694.309381@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18690.48372.369694.309381@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Steve Evans <jeeping@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>> mdadm --assemble --force --run /dev/md1 /dev/sdb1 /dev/sdd1
>>
>> Did work partially -
>>
> Hmm.. That really shouldn't have worked.  The kernel should have
> rejected the array...

Did you notice: 2.6.8-3-686
mdadm - v1.9.0 - 04 February 2005

I don't really recall the history of md and mdadm but I'd suggest trying to
repair in a modern recovery/live-CD environment.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
