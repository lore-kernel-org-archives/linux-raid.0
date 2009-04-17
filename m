From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 17 Apr 2009 13:49:41 +1000
Message-ID: <18919.64597.426128.498393@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday April 6
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 6, dledford@redhat.com wrote:
> On Apr 1, 2009, at 6:46 PM, Neil Brown wrote:
> 
> > On Wednesday April 1, jnelson-linux-raid@jamponi.net wrote:
> >> ping?
> >
> > Oh yeah, that's right, I was going to reply to that - thanks for the
> > reminder.
> >
> >>
> >> On Tue, Mar 24, 2009 at 11:57 AM, Jon Nelson
> >> <jnelson-linux-raid@jamponi.net> wrote:
> >>>
> >>> I have a raid1 comprised of a local physical device (/dev/sda) and a
> >>> network block device (/dev/nbd0).
> >>> When the machine hosting the network block device comes up, however,
> >>> it creates /dev/md127.
> >>> Why?
> >
> > Because you cannot please all the people, all the time.
> 
> Very true.

And I fear I'm going to be displeasing again :-(

> 
> >
> > People seem to want their arrays to auto-assemble - you know, just
> > appear and do the right thing, read their mind probably, because
> > creating config files is too hard.
> > So I've endeavoured to make that happen.
> >
> > The biggest problem with auto-assembly is what to do if two arrays
> > claim to have the same name. (e.g. /dev/md0) - which one wins.
> > The 'homehost' is (currently) used to resolve that.  An array only
> > gets to use the name it claims to have if it can show that it belongs
> > to "this" host.  If it doesn't it still get assembled, but with some
> > other more generic name.
> 
> FWIW, I happen to disagree with this method.  And I'm currently  
> testing out a new algorithm for this in Fedora 11 beta.

Thank you for explaining this in such detail.
There are aspects of it that I don't like, but I think there might be
pieces that I can take away from it too.

As you probably know, my preferred solution is to have all arrays
listed in /etc/mdadm.conf.  If it isn't in mdadm.conf, it doesn't get
assembled.   But I don't have a lot of company in this opinion.  Lots
of people want to have arrays assembled without them being in
mdadm.conf, and I'm trying to work with that.

Parts of what you are proposing seem to involve expecting people to
take a middle ground with some arrays listed in mdadm.conf and other
that aren't.  I'm not sure I'm happy with expecting people to do that
(though of course I'm happy to support it).
So the various parts of your algorithm which involve heuristics
based on the entries in mdadm.conf - or on the existence of mdadm.conf
itself - are parts that I don't feel comfortable with.

What is left?  Well, the observation that moving an external
multi-drive enclosure between hosts causes confusing naming is a valid
and useful observation.

Someone should be able to create an array on such a device called
'foo' and get '/dev/md/foo' created on any host.
The best thought I have come to so far is to support (and document)
something like
  --create --homehost=any
or
  --create --homehost=*

with the meaning that the array so created will get preferential
access to it's recorded name (i.e. no "_0" suffix).

I also wonder if, when mdadm finds an array that is explicitly for
another host, we could use that host name rather than _0 to
disambiguate.  So
  --create /dev/md/foo --homehost=bob
when assembled on some other host is called
       /dev/md/foo_bob
that might at least make it more obvious what is happening.


Note that 0.90 metadata does contain homehost information to some
extent.  When homehost is set, the last few bytes of the uuid is set
from a hash of the homehost name.  That makes it possible to test if a
0.90 array was created for 'this' host, but not to find out what host
it was created for.  So the above expedient won't work for 0.90
arrays, but the rest of the homehost concept (including any possible
'homehost=any' option) does.

You note that arrays with no homehost are treated as foreign with not
always being a good thing.  In 3.0, homehost is no longer optional.
If it is not explicitly set, it will default to `uname -n`.  So newly
created arrays will not suffer from this problem.  Arrays created with
mdadm 2.x do.  They can be 'upgraded' with
    --assemble --update=homehost
which is a suggestion that should be put in the man page.

Your idea of allowing the names "/dev/md0" and "md0" to connect with the
minor number '0' in the same way that the name "0" does is a good
one.  I have implemented that.

I think I am leaning towards 'homehost=any' rather than 'homehost=*'
and will implement that. (No one would have a computer called 'any'
would they?).

Thanks again for your input.

NeilBrown




> 
> The logic behind this in mdadm-3.0devel3 is basically "if the array  
> exists in mdadm.conf or if it has this homehost, assemble using normal  
> name, else use a random name".  However, in the world of movable  
> arrays (think one of those 5 disk SATA raid towers that just has a  
> single eSATA port and a port replicator, which can easily be moved  
> from machine to machine), this doesn't work so well.  The problem is  
> that when you assemble an array with a random number, you confuse  
> users.  They might find the array eventually, but it's certainly not  
> as easy as if the array used the name they expected.  In an attempt to  
> get mdadm to not possibly conflict with local array names, the  
> homehost method of selecting which array name to use causes confusion  
> all the time, instead of only confusing users when a conflict actually  
> occurs.  This doesn't make sense to me, so I redid the tests in mdadm  
> to change this (this is exacerbated by the fact that if your array  
> does not define a homehost, it gets treated as though it has a  
> different homehost, so common version 0.90 arrays will always get  
> assembled as a random number if they aren't in the mdadm.conf file  
> whether they are meant for this host or not).
> 
> So, my logic goes like this:
> 
> Does the array match an array mdadm.conf via uuid?  If yes, use name  
> from mdadm.conf.  If no, does the array match an entry in mdadm.conf  
> via the standard super-minor/name mapping?  If yes, and that array  
> line contains a uuid that doesn't match this entry, then use a random  
> name because this is likely a conflict.  If yes and that line does not  
> contain a uuid entry, then this is likely a match, but a poor one.   
> Use the name, but don't like it.  If no, then this array didn't match  
> the mdadm.conf file at all and is likely a foreign array.  However, if  
> there is no mdadm.conf file, or if there is a mdadm.conf file and  
> nothing in it used our name, then foreign or not, it likely won't  
> conflict on name, so go ahead and use the standard name for this device.
> 
> I had to modify the match loop to store both uuid and name matches  
> separately in order to support this logic.  There's some other changes  
> that were necessary in order to make it work properly, and I had to  
> change mdopen.c to automatically go from what we thought was a good  
> name to a random name if a conflict on an array happens in order to  
> avoid failed autoassembles.  However, I'm personally much happier with  
> the results.  For example, I can define md0 in the mdadm.conf file,  
> create two different md0 arrays, then attempt to autoassemble the one  
> that isn't in mdadm.conf and it will automatically get a random name  
> and when the one that is in mdadm.conf shows up it gets the right  
> name.  I can also define to md0 arrays with neither of them in the  
> mdadm.conf file and it will assemble the first as md0 and the second  
> as name md0_0 with a random minor (I think, it's been a week or so  
> since I did that testing).  Anyway, it works well, and it basically  
> negates the need for homehost in my opinion.  And the fact that it  
> only assembles an array with a random number when it truly needs to is  
> something that will help to greatly reduce confusion of users, which  
> is always a plus in my book.  I'll attach the patch for your review.   
> I could have shortened the logic in the match tests to just what's  
> needed to set things right, but I left the long version so people can  
> see all the possible options and why a specific setting is chosen on  
> any given option.  Oh, and the patch also loosens up the name matching  
> somewhat so that if someone names their device /dev/md0, that matches  
> super-minor 0, as does md0 and just plain 0.  The original match  
> setup, at least for devices not in the mdadm.conf file with a name in  
> the array line, would only match the array name if it was numeric only  
> (aka, homehost:0 or just 0).  I found that to be overly restrictive  
> and contrary to what a lot of people would expect should be entered in  
> the name field of the superblock.
> 
> Since I'm sending this anyway, I'll send a couple other changes I made  
> to our mdadm in separate mails.
> 
> 
> 
> --
> 
> Doug Ledford <dledford@redhat.com>
> 
> GPG KeyID: CFBFF194
> http://people.redhat.com/dledford
> 
> InfiniBand Specific RPMS
> http://people.redhat.com/dledford/Infiniband
> 
> 
> 
> 
