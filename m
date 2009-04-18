From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 10:12:53 +0200
Message-ID: <20090418081239.GB2124@maude.comedia.it>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Apr 17, 2009 at 02:17:47PM -0400, Doug Ledford wrote:
> This appears to be the difference between a server setup and a desktop 
> setup.  Server admins want to list things and only have known actions 
> happen.  Desktop people want things to "just work".  I've had several 
> people tell me they thought the idea of mdadm.conf was completely out of 
> date and it should just go away entirely.  Not saying I agree, just letting 
> you know what I get.
uhm, udev should be able to assemble an array without mdadm.conf, not
that i like it

>> Parts of what you are proposing seem to involve expecting people to
>> take a middle ground with some arrays listed in mdadm.conf and other
>> that aren't.
>
> I do this myself FWIW.  My / and /boot arrays are in mdadm.conf, but arrays 
> that I plug in via USB, eSATA, etc. are not.
>
>>  I'm not sure I'm happy with expecting people to do that
>> (though of course I'm happy to support it).
>
> I really don't expect them to per se.  More like it's the *safe* thing to 
> do.  If you ever have a conflict in names, the one in the file wins.  If 
> you ever have a conflict in names without one of them in the file, then 
> it's whoever got there first.  In that sense, mdadm.conf is just a backup 
> for me.  Well, that and mkinitrd doesn't do incremental assembly, so it's 
> needed for boot in my case.  But that could be changed.
yes, if we ensure it will mount the correct array :)

i was wondering about indicating our preference to policy in mdadm.conf
ie

POLICY {dynamic|preferred|strict}

dynamic: assemble anything you find, naming policy first come first
served. this might be the only line in mdadm.conf

preferred (in need of a better name): arrays defined here have
precedence over dynamically found arrays

strict: if it ain't here, just ignore it

....
> This is a bad idea, and just reinforces my thought that we shouldn't be 
> paying attention to homehost.  Amongst the most important aspects are 
> machines that are booted up, installed, raid arrays created during install, 
> then shut down and moved, likely changing dhcp hostnames in the process.  
> Now all your homehosts belong to some hostname in some IT guys install 
> network instead of in your final network.  At install time, it's actually 
> fairly common that the hostname is not yet set, especially at raid array 
> creation time.
i never found much use for homehost, i would prefer to have a stricter
locking mechanism for shared storage (maybe integration of cman
locking???) and leave the desktop world with randomic names.
If you get the first case wrong you risk damaging data.
If you get the array name wrong on a desktop i expect the luser will
never even notice as long a windows pops up showing the filesystem
contents :P

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
