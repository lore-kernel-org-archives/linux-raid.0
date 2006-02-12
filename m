From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: shared spare
Date: Sun, 12 Feb 2006 16:29:53 +1300
Message-ID: <43EEABB1.3010104@sauce.co.nz>
References: <43ED1869.9000104@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43ED1869.9000104@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> One of the things I like about the IBM ServeRAID controller is spare 
> drive shared between two RAID groups. First to fail gets it. For 
> software RAID is this at all in the future?

Hi Bill,

Unless I am misunderstanding something, software RAID has this already.
I have not used it but reading from the mdadm man page in the "Monitor
Mode" section:

"As  well  as  reporting  events, mdadm may move a spare drive from one
array to another if they are in the same spare-group and if the
destination array has a failed drive but not spares."

Regards,

Richard




