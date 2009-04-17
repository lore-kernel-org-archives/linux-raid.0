From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 17 Apr 2009 14:17:47 -0400
Message-ID: <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-6--307937061"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18919.64597.426128.498393@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-6--307937061
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 16, 2009, at 11:49 PM, Neil Brown wrote:
> On Monday April 6, dledford@redhat.com wrote:
>> On Apr 1, 2009, at 6:46 PM, Neil Brown wrote:
>>
>>> On Wednesday April 1, jnelson-linux-raid@jamponi.net wrote:
>>>> ping?
>>>
>>> Oh yeah, that's right, I was going to reply to that - thanks for the
>>> reminder.
>>>
>>>>
>>>> On Tue, Mar 24, 2009 at 11:57 AM, Jon Nelson
>>>> <jnelson-linux-raid@jamponi.net> wrote:
>>>>>
>>>>> I have a raid1 comprised of a local physical device (/dev/sda)  
>>>>> and a
>>>>> network block device (/dev/nbd0).
>>>>> When the machine hosting the network block device comes up,  
>>>>> however,
>>>>> it creates /dev/md127.
>>>>> Why?
>>>
>>> Because you cannot please all the people, all the time.
>>
>> Very true.
>
> And I fear I'm going to be displeasing again :-(
>
>>
>>>
>>> People seem to want their arrays to auto-assemble - you know, just
>>> appear and do the right thing, read their mind probably, because
>>> creating config files is too hard.
>>> So I've endeavoured to make that happen.
>>>
>>> The biggest problem with auto-assembly is what to do if two arrays
>>> claim to have the same name. (e.g. /dev/md0) - which one wins.
>>> The 'homehost' is (currently) used to resolve that.  An array only
>>> gets to use the name it claims to have if it can show that it  
>>> belongs
>>> to "this" host.  If it doesn't it still get assembled, but with some
>>> other more generic name.
>>
>> FWIW, I happen to disagree with this method.  And I'm currently
>> testing out a new algorithm for this in Fedora 11 beta.
>
> Thank you for explaining this in such detail.
> There are aspects of it that I don't like, but I think there might be
> pieces that I can take away from it too.
>
> As you probably know, my preferred solution is to have all arrays
> listed in /etc/mdadm.conf.  If it isn't in mdadm.conf, it doesn't get
> assembled.   But I don't have a lot of company in this opinion.  Lots
> of people want to have arrays assembled without them being in
> mdadm.conf, and I'm trying to work with that.

This appears to be the difference between a server setup and a desktop  
setup.  Server admins want to list things and only have known actions  
happen.  Desktop people want things to "just work".  I've had several  
people tell me they thought the idea of mdadm.conf was completely out  
of date and it should just go away entirely.  Not saying I agree, just  
letting you know what I get.

> Parts of what you are proposing seem to involve expecting people to
> take a middle ground with some arrays listed in mdadm.conf and other
> that aren't.

I do this myself FWIW.  My / and /boot arrays are in mdadm.conf, but  
arrays that I plug in via USB, eSATA, etc. are not.

>  I'm not sure I'm happy with expecting people to do that
> (though of course I'm happy to support it).

I really don't expect them to per se.  More like it's the *safe* thing  
to do.  If you ever have a conflict in names, the one in the file  
wins.  If you ever have a conflict in names without one of them in the  
file, then it's whoever got there first.  In that sense, mdadm.conf is  
just a backup for me.  Well, that and mkinitrd doesn't do incremental  
assembly, so it's needed for boot in my case.  But that could be  
changed.

> So the various parts of your algorithm which involve heuristics
> based on the entries in mdadm.conf - or on the existence of mdadm.conf
> itself - are parts that I don't feel comfortable with.
>
> What is left?  Well, the observation that moving an external
> multi-drive enclosure between hosts causes confusing naming is a valid
> and useful observation.
>
> Someone should be able to create an array on such a device called
> 'foo' and get '/dev/md/foo' created on any host.
> The best thought I have come to so far is to support (and document)
> something like
>  --create --homehost=any
> or
>  --create --homehost=*
>
> with the meaning that the array so created will get preferential
> access to it's recorded name (i.e. no "_0" suffix).
>
> I also wonder if, when mdadm finds an array that is explicitly for
> another host, we could use that host name rather than _0 to
> disambiguate.  So
>  --create /dev/md/foo --homehost=bob
> when assembled on some other host is called
>       /dev/md/foo_bob
> that might at least make it more obvious what is happening.

This is probably where you and I disagree.  I don't think you are  
disambiguating.  I think you are confounding the common case of no  
conflict.  If someone has a non-portable array, like /, they commonly  
use something like /dev/md0.  That, you will likely never get a  
conflict on.  On the other hand, if someone creates an array to be  
mobile, it will likely have a higher number (or it could be 0, but  
that implies they aren't using root raid arrays on their machines in  
all likelihood).  So, if you make a mobile array, just give it any old  
number you can remember other than the normal base numbers used by non- 
portable arrays, and viola, no conflicts (note that this is also why I  
was in favor of a completely numberless md setup, where device  
major:minor do not impact name of the array at all, and you are free  
to create something like /dev/md/root and there will be no access file  
other than /dev/md/root, specifically no alias from /dev/md0 to /dev/ 
md/root...it's much easier to remember names than numbers, and much  
easier to create a scheme that avoids conflicts 100% of the time).  As  
it stands though, the current code still won't honor random names as  
though that was the official and canonical name of the array, it  
insists on creating a /dev/md# device and then just symlinking the  
name as though the /dev/md# device is canonical.  In one of your  
previous emails you mentioned something about how bad design decisions  
get entrenched and can never be rooted out, I would point to this ;-)

> Note that 0.90 metadata does contain homehost information to some
> extent.  When homehost is set, the last few bytes of the uuid is set
> from a hash of the homehost name.  That makes it possible to test if a
> 0.90 array was created for 'this' host, but not to find out what host
> it was created for.  So the above expedient won't work for 0.90
> arrays, but the rest of the homehost concept (including any possible
> 'homehost=any' option) does.
>
> You note that arrays with no homehost are treated as foreign with not
> always being a good thing.  In 3.0, homehost is no longer optional.
> If it is not explicitly set, it will default to `uname -n`.  So newly
> created arrays will not suffer from this problem.  Arrays created with
> mdadm 2.x do.  They can be 'upgraded' with
>    --assemble --update=homehost
> which is a suggestion that should be put in the man page.

This is a bad idea, and just reinforces my thought that we shouldn't  
be paying attention to homehost.  Amongst the most important aspects  
are machines that are booted up, installed, raid arrays created during  
install, then shut down and moved, likely changing dhcp hostnames in  
the process.  Now all your homehosts belong to some hostname in some  
IT guys install network instead of in your final network.  At install  
time, it's actually fairly common that the hostname is not yet set,  
especially at raid array creation time.

> Your idea of allowing the names "/dev/md0" and "md0" to connect with  
> the
> minor number '0' in the same way that the name "0" does is a good
> one.  I have implemented that.
>
> I think I am leaning towards 'homehost=any' rather than 'homehost=*'
> and will implement that. (No one would have a computer called 'any'
> would they?).
>
> Thanks again for your input.

No problem.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-6--307937061
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknox8wACgkQQ9aEs6Ims9hZlwCeIubggF3W5arK5JtrTfFA5dNK
xEAAn1IdFYNIFXGeQc2Dm4uF4lBM3iUY
=M4ak
-----END PGP SIGNATURE-----

--Apple-Mail-6--307937061--
