From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: RAID10 and 'writemostly' support
Date: Fri, 17 Feb 2017 01:24:50 +0000
Message-ID: <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/17 14:08, Reindl Harald wrote:
> Hi
>
> i am new and was redirected to this list from the bugtracker
> please have a look at https://bugzilla.kernel.org/show_bug.cgi?id=194551
>
> currently "writemostly" seems to be only supported on "real" RAID1 while
> i was in hope that by the conecpt of RAID10 having more or less
> RAID0+RAID1 it would also work on RAID10 (and on the virtual machine wre
> i tested mdadm with the flag before buying the disks it did not complain)

Be careful. Don't confuse Raid10 with Raid1+0. They are NOT the same 
thing (on linux at least), although they are very similar.

Cheers,
Wol
