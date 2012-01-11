From: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Subject: Re: Renaming MD devices (metadata=1.1)
Date: Wed, 11 Jan 2012 01:39:59 -0500
Message-ID: <4F0D2EBF.5070807@grm.polymtl.ca>
References: <4F0BD6EA.8010007@grm.polymtl.ca> <4F0C1A03.8020509@ziu.info> <4F0D272A.2060000@grm.polymtl.ca> <20120111172047.6af5571f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120111172047.6af5571f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

[...]
>>> As the /dev/md9 was explicitly given in this form, the 
>>> MD_DEVNAME was not present in 'mdadm --detail --export' output,
>>> thus /dev/md/9 was not created by mdadm's udev rules - but it
>>> would have been if you had done mdadm --assemble /dev/md/9 ...
>> 
>> Ok, I think I follow this, but I am not sure.
>> 
>> What you are saying is that I am getting /dev/md127 because it's
>>  not being created by udev right?
> 
> You are getting md127 because you asked for 
> "/dev/md/xyz.home.linux.com:9" so it gave you that (look in 
> /dev/md) but it needs to give an 'mdXX' name to the kernel so it 
> chose 127 (because that is where it starts looking for free 
> numbers) and used that.  Don't worry about  the /dev/mdXX.  You 
> asked for "/dev/md/xyz.home.linux.com:9' in mdadm.conf,  you got, 
> so just use it and ignore the rest.

OK, I think it makes sense now.


[...]
>> so expliciting the metadata=x is not needed? What's its use?
> 
> Documentation. It doesn't hurt, and I want "mdadm -Db" to report 
> it, so if I allow it in mdadm.conf then it is easier to use the 
> output of "mdadm -Db" in mdadm.conf.

I see. Well, that's also good to know.

While we are at it, what is the reasons types 1.0, 1.1 and 1.2 exist?
- From what I understand "either at the end (for 1.0), at the start (for
1.1) or 4K from the start (for 1.2)".

Why do we have these choices, and when should each be used?


>>> So to sum it up - if '9' is what you're after - then the ARRAY
>>>  line with just UUID is all you should be needing - and you 
>>> should always get /dev/md/9 (pointing to something else 
>>> assigned dynamically).
>>> 
>>> If udevd is not running (hardly interesting case anymore), then
>>> mdadm will fall back to the pre-udev behavior and setup the
>>> nodes itself, though the rules are slightly different then.
>> 
>> I just left ARRAY UUID=0fa7f737:7806ca61:fb89edd6:14aa351a in 
>> /etc/mdadm.conf, rebooted, and it's still appearing as 
>> /dev/md127.
> 
> Just as I would expect.  You didn't ask for a specific number, so 
> it just chose an arbitrary one.

Ok.


>> So I am not sure why... What may I be missing?
> 
> Don't know.  Maybe you are expecting something that isn't needed.
> 
> What exactly do you want?  And why?

Well, to be honest, what I *really* wanted was to understand why I
wasn't able to rename the arrays. I wanted to understand what the
system was doing, because I don't like not understanding why my setup
doesn't behave the way I expect it to. So, I wanted to learn what I
was missing in my understanding.

How I came about wanting to know this is because I tried renaming the
devices, and it wasn't working, despite me reading different people's
posts on the net. I tried reading the documentation too, but I somehow
missed reading about the updating of initramfs (I thought I only
needed to do that if the device where "/" is changed names).

Indeed, I could have continued keeping these devices named /dev/md127
etc (there is no harm in having those names), but my mind just doesn't
work that way...
I had the need of understanding what was happening and why whatever I
was trying to do wasn't working :)

So I came about to your contributions to the source code, then to your
blog page, then from there to emailing this list as you suggested :)

I figured that if I were to ask these questions, I had to give as much
info as possible to avoid wasting your time (which is why I pasted all
the info I thought could matter, and tried to organize it a bit... as
far as I had come to understand it).

That's the whole story.

So thanks again for taking the time for reading all of this :)
You guys were really responsive!

I wish you all a nice week!

Gilbert
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (Darwin)
Comment: digital signature
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8NLrgACgkQOYVp1RpLsmU91gCghIixD+I5czrVAlNifcr7A20Z
QqIAoJaveKMWAzNybI4R1gX0YTsYoYal
=wjtT
-----END PGP SIGNATURE-----
