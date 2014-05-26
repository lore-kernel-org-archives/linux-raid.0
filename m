From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Seeking help fixing a failed array
Date: Mon, 26 May 2014 15:28:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1405261521540.29282@uplift.swm.pp.se>
References: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com> <alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se> <CAGcAkBJCbjwCQO-UU5kmQb_7Ly5ThxxhMJba9ftOn566VbbR9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGcAkBJCbjwCQO-UU5kmQb_7Ly5ThxxhMJba9ftOn566VbbR9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marnitz Gray <marnitz@xdesigns.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 26 May 2014, Marnitz Gray wrote:

> Hi Mikael
>
> Thanks for the reply
>
> On Sat, May 24, 2014 at 11:36 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> On Fri, 23 May 2014, Marnitz Gray wrote:
>>
>>> Hello good people of linux-raid.
>>
>>
>> Your output seems to indicate that you have one drive with an event count
>> that is 6 events off the others. This most likely means it's safe to use
>> --assemble --force in order to make this get accepted.
>
> Thanks, as per my original email I get an error message: "...assembled
> from 3 drives and 1 spare - not enough to start the array ". Am I
> doing something wrong?

Hm, I just noticed this was with --force already.

From your log:
mdadm: added /dev/sde to /dev/md0 as 1
mdadm: added /dev/sdd to /dev/md0 as 2
mdadm: added /dev/sdb to /dev/md0 as 3 (possibly out of date)
mdadm: no uptodate device for slot 8 of /dev/md0
mdadm: added /dev/sdc to /dev/md0 as 5
mdadm: added /dev/sdf to /dev/md0 as 0
mdadm: /dev/md0 assembled from 3 drives and 1 spare - not enough to
start the array.

I don't know how to make the drives that are set as faulty to be 
considered non-faulty. It looks like you have all the drives needed but 
that they're not considered ok.

Let's hope someone else can answer. You could probably get everything 
working by doing a correct --create --assume-clean command but I don't 
feel comfortable enough to give you an advice what the command should be 
exactly (order, offset etc). It would be good to understand why the drives 
marked faulty aren't used with --assemble-force though.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
