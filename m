From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help please: 2-5 tps on write with 98% iowait
Date: Thu, 26 Jan 2012 20:18:16 -0600
Message-ID: <4F220968.4050902@hardwarefreak.com>
References: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com> <4F21B5E1.7070207@hardwarefreak.com> <20120126155742.736c7886@pog.tecnopolis.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120126155742.736c7886@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Trevor Cordes <trevor@tecnopolis.ca>
Cc: linux-raid@vger.kernel.org, Seth Jennings <spartacus06@gmail.com>
List-Id: linux-raid.ids

On 1/26/2012 3:57 PM, Trevor Cordes wrote:
> On 2012-01-26 Stan Hoeppner wrote:
>> On 1/25/2012 12:15 PM, Seth Jennings wrote:
>>> The write performance on my raid5 took a nose dive yesterday
>>
>> Simply identify what changed between the 24th and 25th, if indeed this
>> problem started on the 25th.
> 
> Check my very last email to the mailing list, re: WD Green drives.  If
> you have WD Greens, esp EADS ones, that's your problem probably.

On 1/25/2012 12:15 PM, Seth Jennings wrote:

> /dev/sda: 250GB single part
> /dev/sdb: 250GB single part
> /dev/sdc: 500GB, 2x250GB parts
> /dev/sdd: 320GB, 250GB and 70GB parts

Trevor, which of the OP's 4 drives mentioned in his initial post do you
believe to be a WD Green?

-- 
Stan
