From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 09:18:28 +0000
Message-ID: <CAHQw7YAZtNiZ-AAAQ=2DvcEy_wGK4pe1zYkXmQ85pa+4pxMGKQ@mail.gmail.com>
References: <201109221950.36910.tfjellstrom@shaw.ca> <20110923151108.08c1199f@notabene.brown>
 <201109222322.57040.tfjellstrom@shaw.ca> <201109230209.36209.thomas@fjellstrom.ca>
 <20110923191539.110b7be1@notabene.brown> <4E7E5266.5040205@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7E5266.5040205@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Sep 24, 2011 at 9:57 PM, Aapo Laine <aapo.laine@shiftmail.org> =
wrote:
>
> On 09/23/11 11:15, NeilBrown wrote:
>>
>> On Fri, 23 Sep 2011 02:09:36 -0600 Thomas Fjellstrom<thomas@fjellstr=
om.ca>
>> wrote:
>>>
>>> I forgot to say, but: Thank you very much :) for the help, and your=
 tireless
>>> work on md.
>>>
>>
>> You've very welcome .... but I felt I needed to respond to that word
>> "tireless".
>> The truth is that I am getting rather tired of md .... if anyone kno=
ws anyone
>> who wants to get into kernel development and is wondering where to s=
tart -
>> please consider whispering 'the md driver' in their ear. =A0Plenty t=
o do, great
>> mentoring possibilities, and competent linux kernel engineers with g=
ood
>> experience are unlikely to have much trouble finding a job ;-)
>>
>> NeilBrown
>
> Whoa this is shocking news!
>
> Firstly then, thank you so much for your excellent work up to now. Li=
nux has what I believe to be the best software raid of all operating sy=
stems thanks to you. Excellent in both features, and reliability i.e. q=
uality of code.
>
> And also the support through the list was great. I found so many prob=
lems solved already just by looking at the archives... so many people w=
ith their arse saved by you.
>
> I think everybody here is sorry to see you willing to go.
>
> Now the bad news... Regarding the MD takeover, there I think I see a =
problem...
> The MD code is very tersely commented, compared to its complexity!
>
> - there is not much explanation of overall strategies, or the structu=
re of code. Also the flow of data between the functions is not much exp=
lained most of the times.
>
> - It's not obvious to me what is the entry point for kernel processes=
 related to MD arrays, how are they triggered and where do they run... =
E.g. in the past I tried to understand how did resync work, but I could=
n't. I thought there was a kernel process controlling resync advancemen=
t, but I couldn't really find the boundaries of code inside which it wa=
s executing.
>
> - it's not clear what the various functions do or in what occasion th=
ey are called. Except from their own name, most of them have no comment=
s just before the definition.
>
> - the algoritms within the functions are very long and complex, but o=
nly rarely they are explained by comments. I am now seeing pieces havin=
g 5 levels of if's nested one inside the other, and there are almost no=
 comments.
>
> - last but not least, variables have very short names, and for most o=
f them, it is not explained what they mean. This is mostly for local va=
riables, but sometimes even for the structs which go into metadata e.g.=
 in struct r1_private_data_s most members do not have an explanation. T=
his is pretty serious, to me at least, for understanding the code.
>
> - ... maybe more I can't think of right now ...
>
> Your code is of excellent quality, as I wrote, I wish there were more=
 programmers like you, but if you now want to leave, THEN I start to be=
 worried! Would you please comment it (much) more before leaving? Fully=
 understanding your code I think is going to take other people a lot of=
 time otherwise, and you might not find a replacement easily and/or s/h=
e might do mistakes.
>
> There were times in the past when I had ideas and I wanted to contrib=
ute code, but when I looked inside MD and tried to understand where sho=
uld I put my changes, I realized I wasn't able to understand what curre=
nt code was doing. Maybe I am not a good enough C programmer, but I was=
 able to change things in other occasions.
>
>
> I hope you won't get these critiques bad...
> and thanks for all your efforts, really, in the name of, I think, eve=
rybody.
> Aapo L.
> --

Thank you Mr. Brown for the immensely useful mdadm. In its simplicity,
it is mastery of craft, purely functional to the point that it attains
an inherent beauty of form.

Re. Aapo's comments, a GitHub repository of mdadm could be the ticket.
A de-facto Github merge maintainer owns a master repo, say
"mdadm-documented". People fork from it at will, creating comments for
the code and / or increasing intuitive readability if need be.
Maintaner merges it all, creating a mdadm version that is functionally
identical to mdadm stable but sort of pedagogically smoothed :)

The mdadm maintainer could then merge this into the actual mdadm head a=
t will.

If it takes off, this would take the load off Neil's shoulders =96 plus
it's sometimes easier for fresh eyes to see things in context when the
initial work of building the full mental picture is done.

-kd
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
