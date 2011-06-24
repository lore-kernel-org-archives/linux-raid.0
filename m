From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: Looking for the best way to do this
Date: Fri, 24 Jun 2011 12:17:45 -0400
Message-ID: <4E04B8A9.1050502@cdf.toronto.edu>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu> <4E03B8DB.7010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E03B8DB.7010607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maurice,

On 06/23/11 18:06, maurice wrote:
> What I do NOT know is the following:
> A) Which is more RELIABLE: R1 with 3 disks or R10 with 3 disks.

R10 has different layouts. There are two components to the layout - 
where the chunks are located on the different devices (near, offset, 
far), and number of copies of the data. The near/offset/far part of the 
layout does not play a role in reliability, just in performance. So, the 
number of copies is the only thing that matters to this discussion.

If you have R10 with 3 disks and 3 copies, it is equally reliable to R1 
with 3 disks, as they have an equal number of copies. In both R10 and R1 
in this case, two disks can fail, and you still have 1 intact copy 
remaining.

> B) HOW to create either the 3 disk R1 or R10, assuming an existing 2
> disk R1.

If there is an existing R1, and you just want to add an extra device to 
it, it's easy - you just have to "grow" the array to increase the number 
of devices, and then "add" a device, and it'll become a 3 device R1. I 
don't think you'd want to switch to R10 if you are looking to just add a 
3rd device to an existing R1!

Example:

mdadm --grow -n 3 /dev/md0
mdadm /dev/md0 --add /dev/sdc1

Does that help?

Cheers,
Iordan
