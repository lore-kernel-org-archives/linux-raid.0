From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm create to existing raid5
Date: Fri, 13 Jul 2007 09:25:06 +0100
Message-ID: <469736E2.7040802@dgreaves.com>
References: <200707122318.l6CNIao08247@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707122318.l6CNIao08247@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jon Collette' <jon@etelos.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> } owner@vger.kernel.org] On Behalf Of Jon Collette
> } I wasn't thinking and did a mdadm --create to my existing raid5 instead
> } of --assemble.  The syncing process ran and now its not mountable.  Is
> } there anyway to recover from this?
> Maybe.  Not really sure.  But don't do anything until someone that really
> knows answers!
I agree - Yes, maybe.


> What I think...
> If you did a create with the exact same parameters the data should not have
> changed.  But you can't mount so you must have used different parameters.
I'd agree.


> Only 1 disk was written to during the create.
Yep.

>  Only that disk was changed.
Yep.

> If you remove the 1 disk and do another create with the original parameters
> and put "missing" for the 1 disk your array will be back to normal, but
> degraded.  Once you confirm this you can add back the 1 disk.
Yep.
**WARNING**
**WARNING**
**WARNING**
At this point you are relatively safe (!) but as soon as you do an 'add' and 
initiate another resync then if you got it wrong you will have toasted your data 
completely!!!
**WARNING**
**WARNING**
**WARNING**

>  You must be
> able to determine which disk was written to.  I don't know how to do that
> unless you have the output from "mdadm -D" during the create/syncing.

Do you know the *exact* command you issued when you did the initial --create?
Do you know the *exact* command you issued when you did the bogus --create?

And what version of mdadm you are using?

Neil said that it's mdadm, not the kernel, that determines which device is 
initially degraded during a create. We can look at the code and your command 
line and guess which device mdadm chose. (Getting this wrong won't matter but it 
may make recovery quicker.)

assuming you have a 4 device raid using /dev/sda1, /dev/sdb1, /dev/sdc1, /dev/sdd1

you'll then do something like:
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sda1 /dev/sdb1 
/dev/sdc1 missing
try a mount
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sda1 missing 
/dev/sdc1 /dev/sdb1
try a mount
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdb1 /dev/sda1 
/dev/sdc1 missing
try a mount
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdc1 /dev/sdb1 
/dev/sda1 missing
try a mount

etc etc,

So you'll still need to do a trial and error assemble....
For a simple 4 device array I there are 24 permutations - doable by hand, if you 
have 5 devices then it's 120, 6 is 720 - getting tricky ;)

I'm bored so I'm going to write a script based on something like this:
http://www.unix.org.ua/orelly/perl/cookbook/ch04_20.htm

Feel free to beat me to it ...

The critical thing is that you *must* use 'missing' when doing these trial 
--create calls.

If we've not explained something very well and you don't understand then please 
ask before trying it out...

David
