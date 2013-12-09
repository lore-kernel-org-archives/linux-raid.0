From: Christopher Hoover <ch@murgatroid.com>
Subject: Re: unable to assemble (mostly?) clean array
Date: Sun, 8 Dec 2013 17:08:19 -0800
Message-ID: <CACw0PsaCzZAKWeh9MxXK39Fpwh5wg-bjHHMY0-0djW+59Qf-jQ@mail.gmail.com>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
 <52A5089D.3080109@websitemanagers.com.au> <CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
 <20131209120217.54dd3082@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209120217.54dd3082@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ch@snaggle:~$ sudo mdadm --assemble --verbose  --force /dev/md0  /dev/sd[defg]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
mdadm: ignoring /dev/sde1 as it reports /dev/sdd1 as failed
mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sdg1 to /dev/md0 as 5
mdadm: added /dev/sdd1 to /dev/md0 as 4
mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
start the array.
ch@snaggle:~$

On Sun, Dec 8, 2013 at 5:02 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 8 Dec 2013 16:32:22 -0800 Christopher Hoover <ch@murgatroid.com>
> wrote:
>
>> yes, thanks, typo there.  that was done hastily for the e-mail.
>>
>> i had tried the right thing previously and here it is again.  still no luck:
>>
>>
>> ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1 | egrep 'Events|^/dev/sd'
>> /dev/sdd1:
>>          Events : 286024
>> /dev/sde1:
>>          Events : 286011
>> /dev/sdf1:
>>          Events : 286024
>> /dev/sdg1:
>>          Events : 286024
>> ch@snaggle:~$ sudo mdadm --assemble --force /dev/md0  /dev/sd[dfg]1
>> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
>> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
>> start the array.
>> ch@snaggle:~$
>
> Please try listing *all* of the devices, and add "-v" for extra output.
>
> NeilBrown
