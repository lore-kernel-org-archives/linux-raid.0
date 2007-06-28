From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm usage: creating arrays with helpful names?
Date: Thu, 28 Jun 2007 09:12:56 +0100
Message-ID: <46836D88.9010708@dgreaves.com>
References: <20070626235402.GA27852@server> <46821682.6050602@dgreaves.com> <20070627235739.GA30527@server>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627235739.GA30527@server>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>, Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(back on list for google's benefit ;) and because there are some good questions 
and I don't know all the answers... )

Oh, and Neil 'cos there may be a bug ...

Richard Michael wrote:
> On Wed, Jun 27, 2007 at 08:49:22AM +0100, David Greaves wrote:
>> http://linux-raid.osdl.org/index.php/Partitionable
>>
> 
> Thanks.  I didn't know this site existed (Googling even just 'mdadm'
> doesn't yield it in the first 100 results), and it's helpful.
Good ... I got permission to wikify the 'official' linux raid FAQ but it takes 
time (and motivation!) to update it :)
Hopefully it will snowball as people who use it then contribute back <hint> ;)

As it becomes more valuable to people then more links will be created and Google 
will notice...


> What if don't want a partitioned array?  I simply want the name to be
> nicer than the /dev/mdX or /dev/md/XX style.  (p1 still gives me
> /dev/nicename /dev/nicename0, as your page indicates.)
--auto md

mdadm --create /dev/strawberry --auto md ...
root@ash:/tmp # mdadm --detail /dev/strawberry
/dev/strawberry:
         Version : 00.90.03
   Creation Time : Thu Jun 28 08:25:06 2007
      Raid Level : raid4




> Also, when I use "--create /dev/nicename --auto=p1" (for example), I
> also see /dev/md_d126 created.  Why?  There is then a /sys/block/md_d126
> entry (presumably created by the md driver), but no /sys/block/nicename
> entry.  Why?
Not sure who creates this, mdadm or udev
The code isn't that hard to read and you sound like you'd follow it if you 
fancied a skim-read...

I too would expect that there should be a /sys/block/nicename - is this a bug Neil?

These options don't see a lot of use - I recently came across a bug in the 
--auto p<X> option...

> Finally "--stop /dev/nicename" doesn't remove any of the aforementioned
> /dev or /sys entries.  I don't suppose that it should, but an mdadm
> command to do this would be helpful.  So, how do I remove the oddly
> named /sys entries? (I removed the /dev entries with rm.)  "man mdadm"
> indicates --stop releases all resources, but it doesn't (and probably
> shouldn't).
rm !

'--stop' with mdadm  does release the 'resources', ie the components you used. 
It doesn't remove the array. There is no delete - I guess since an rm is just as 
effective unless you use a nicename...

> [I think there should be a symmetry to the mdadm options
> "--create/--delete" and "--start/--stop".  It's *convenient* --create
> also starts the array, but this conflates the issue a bit..]
> 
> I want to stop and completely remove all trace of the array.
> (Especially as I'm experimenting with this over loopback, and stuff
> hanging around irritates the lo driver.)
You're possibly mixing two things up here...

Releasing the resources with a --stop would let you re-use a lo device in 
another array. You don't _need_ --delete (or rm).
However md does write superblocks to the components and *mdadm* warns you that 
the loopback has a valid superblock..

mdadm: /dev/loop1 appears to be part of a raid array:
     level=raid4 devices=6 ctime=Thu Jun 21 09:46:27 2007

[hmm, I can see why you may think it's part of an 'active' array]

You could do mdadm --zero-superblock to clean the component or just say "yes" 
when mdadm asks you to continue.

see:
# mdadm --create /dev/strawberry --auto md --level=4 -n 6 /dev/loop1 /dev/loop2 
/dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6
mdadm: /dev/loop1 appears to be part of a raid array:
     level=raid4 devices=6 ctime=Thu Jun 28 08:25:06 2007
<blah>
Continue creating array? yes
mdadm: array /dev/strawberry started.

# mdadm --stop /dev/strawberry
mdadm: stopped /dev/strawberry

# mdadm --create /dev/strawberry --auto md --level=4 -n 6 /dev/loop1 /dev/loop2 
/dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6
mdadm: /dev/loop1 appears to be part of a raid array:
     level=raid4 devices=6 ctime=Thu Jun 28 09:07:29 2007
<blah>
Continue creating array? yes
mdadm: array /dev/strawberry started.

David

