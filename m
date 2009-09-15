From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 22:43:53 +0300
Message-ID: <70ed7c3e0909151243o13d1e624w2033bf37b64c987b@mail.gmail.com>
References: <h8ophd$n8p$6@ger.gmane.org> <70ed7c3e0909151224s75cd6c60kc65c2f4e9076e649@mail.gmail.com>
	<1253043199.7774.179.camel@kiste>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253043199.7774.179.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Weird. I haven't seen that before on my disks/partitions.

user@Adam:~$ ls -l /dev/disk/by-uuid/
total 0
lrwxrwxrwx 1 root root 10 2009-09-14 18:05
cf70cb2b-8e1e-44f3-b361-4a27e169eef2 -> ../../sdi1
lrwxrwxrwx 1 root root 10 2009-09-14 18:05
f54698f9-72a0-4226-9ada-34af2699a25c -> ../../sdi5

My array is offline at the moment, so I can't print the disks' info,
but as you can see, each partition has its own UUID, and if each
partition belonged to a different array then it would have a different
UUID.

Sorry for your loss :/

On Tue, Sep 15, 2009 at 10:33 PM, Matthias Urlichs <matthias@urlichs.de> wrote:
> On Tue, 2009-09-15 at 22:24 +0300, Majed B. wrote:
>> Specifying partition names may cause problems if the disk names
>> changed. Specify the UUID instead.
>>
> What I was trying to say is "use a pattern that matches all of your
> partitions and none of your actual disks". That should be safe from
> changing disk file names.
>
> Besides, specifying UUIDs does not work because it runs into the exact
> problem we're trying to solve in the first place. Behold the "blkid"
> output from the server in question:
>
> /dev/sdb2: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid"
> /dev/sdb: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid"
>
> Interestingly, for some reason it doesn't do that with /dev/sda -- most
> probably because the disks in question use different head/sector values
> and thus have slightly different partition layout.
>
>



-- 
       Majed B.
