From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Mon, 22 Apr 2013 00:00:48 +0200
Message-ID: <51746190.30102@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org> <5171F52D.4040701@bucksch.org> <51739405.1060805@fnarfbargle.com> <5173A159.70202@bucksch.org> <5173C353.6080008@fnarfbargle.com> <51742D22.2080601@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51742D22.2080601@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil Turmel wrote, On 21.04.2013 20:17:
> I'm sorry you've been sucked into exchanges with this troll.
>
[referring to me]

Thank you. I came here for help. I *desperately* needed help with an 
actual, real problem. My goal was to rescue my data, and make sure this 
never happens again to anybody else. The goal of a troll is to enrage 
people and cause useless debate.

Before I came here, I had already extensively searched on Google, and 
found lots of unhelpful comments. I wanted to avoid these. 
Unfortunately, I found the same kind of responses here. Responses like 
"You should have used ABC" are not helpful to the problem at hand at 
all, and in fact only serve to enrage the person so "advised". Such 
advise is fair enough when offered *after* actual practical help.

A few people had tried to help, but could not, because apparently there 
is no safe command to do what I need.

>> Again : "Good news: In my desperation, I now ran the following dangerous
>> command: mdadm --create /dev/md0 --assume-clean --level=raid5 -n 8
>> --chunk=64 --layout=left-symmetric --metadata=0.90 /dev/sdj missing
>> /dev/sdl /dev/sd[mopnq]"
> I did find it interesting that Ben tried this on his own, given that's
> the very advice he demanded not be given in his OP.

That's not correct. I wrote:
"Please do NOT respond with re-"create" the array - unless you can give 
me the exact --create command that would recover it with data - other 
people tried this based on suggestions in forums and they lost all data"

Note the "unless". Unfortunately, nonewithstanding my disclaimer, 
several people suggested 1) to use the disk that I already wrote is 
(really, actually) dead 2) hexediting superblocks (without any info on 
how) 3) using --create (ditto), but *nobody* offered the exact command 
to run. (I had posted all relevant device info for that purpose.)

I didn't feel comfortable with --create, but when nobody offered a real 
alternative, I saw no other option than to try that. Yet, I was wrong to 
do that, because:

> The construct /dev/sd[mopnq] expands as if it was specified
> /dev/sd[mnopq].  His misunderstanding of bracket syntax has wrecked his
> array.  If he had used braces, or spelled out all the devices, he'd
> probably be fine right now.
>
> If he tries again, with this in mind, he might still be fine.

Ah, thanks. This is what I consider practical help. Thank you. Indeed, I 
had no idea (not even thought of the mere possibility) that the shell 
would reorder my [] device list. And in fact:
# cat /proc/mdstat
md0 : active raid5 sdq[7] sdp[6] sdo[5] sdn[4] sdm[3] sdl[2] sdj[0]

So, the [] was indeed what killed me and caused my dataloss. 
Unfortunately, the most important FS on the array is now totally corrupted.

FWIW, this is exactly why I had asked for a concrete --create command 
for my case.

> That's a significant consideration when non-native English is 
> involved. But it's clearly not the case here.

FWIW, I am not a native English speaker.

Ben

