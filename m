From: John McMonagle <johnm@advocap.org>
Subject: Re: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 18:02:11 -0600
Message-ID: <4230E003.4040609@advocap.org>
References: <4230BE56.6090905@advocap.org> <4230D279.5090101@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230D279.5090101@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad

Not saying its broke.
Part of my reasoning to go to raid5 was that I could expand.
While it can be done I don't really see it as practical.
Also it's looking like I probably will not need to expand.

raid5 with 3 drives and 1 spare
or 2 - 2 drive raid1 drives have the same space.
Which is less likely to have a failure cause data loss?

I'm guessing raid1.
If I'm wrong I'd like to know now.

Also concerned about the resync times. It was going to take a couple 
days to resync under a rather light load if it weren't for the fact that 
it couldn't because of a bad drive and a kernel panic caused by the read 
error.
Still not certain about the cause of problem my current guess is the 
sata controller.

I'm glad there is work being done on the resync issue.
Also think the ideas to attempt to fix read errors are great.
My only suggestion is that there should be provision to send 
notification when it happens.
With both that would really help.

John

Brad Campbell wrote:

> John McMonagle wrote:
>
>> Was planning to adding a hot spare to my 3 disk raid5 array and was 
>> thinking if I go to 4 drives I would be a  better off  as 2 raid1 
>> arrays considering the current state of raid5.
>
>
> I just wonder about the comment "considering the current state of 
> raid5". What might be wrong with raid5 currently? I certainly know a 
> number of people (me included) who run several "large" raid-5 arrays 
> and don't have any problems.
>
> Brad


