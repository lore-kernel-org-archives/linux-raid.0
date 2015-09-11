From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: raid role number off on one array?
Date: Fri, 11 Sep 2015 10:21:51 -0500
Message-ID: <55F2F18F.4060700@suddenlinkmail.com>
References: <55F249DB.5010908@suddenlinkmail.com> <55F2DD22.3030406@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F2DD22.3030406@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/11/2015 08:54 AM, Phil Turmel wrote:
> /proc/mdstat doesn't show role numbers.  It shows slot numbers.  Slot
> numbers are the indices into the role number tracking tables in the
> superblock.  They happen to match role numbers on a freshly-created
> array simply because the slots are allocated starting from zero, just
> like the roles.  As you add and remove devices, the slot numbers and
> role numbers may no longer match.

Ah hah!

   That was the piece of the puzzle I was missing. Thanks you. I guess I'm just 
a bit overly concerned about making sure I understand everything I'm seeing with 
my arrays. After having used mdadm for roughly a decade without a single loss, 
then having that little "no attempt to activate sda7 Oops", I just want to do 
what I can to avoid a repeat :-)

-- 
David C. Rankin, J.D.,P.E.
