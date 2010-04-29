From: Neil Brown <neilb@suse.de>
Subject: Re: More Hot Unplug/Plug work
Date: Thu, 29 Apr 2010 11:01:53 +1000
Message-ID: <20100429110153.7148bb9b@notabene.brown>
References: <4BD714A3.9020801@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	<4BD874CB.5040803@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	<4BD8A336.7080309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD8A336.7080309@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Wed, 28 Apr 2010 17:05:58 -0400
Doug Ledford <dledford@redhat.com> wrote:

> On 04/28/2010 02:34 PM, Labun, Marcin wrote:
> >>> Going further, thus causes that a new disk can be potentially grabbed
> >> by more than one container (because of shared path).
> >>> For example:
> >>> DOMAIN1: path=a path=b path=c
> >>> DOMAIN2: path=a path=d
> >>> DOMAIN3: path=d path=c
> >>> In this example disks from path c can appear in DOMAIN 1 and DOMAIN
> >> 3, but not in DOMAIN 2.
> >>
> >> What exactly is the use case for overlapping paths in different
> >> domains?
> > 
> > OK, makes sense.
> > But if they are overlapped, will the config functions assign path are requested by configuration file
> > or treat it as misconfiguration?
> 
> For now it merely means that the first match found is the only one that
> will ever get used.  I'm not entirely sure how feasible it is to detect
> matching paths unless we are just talking about identical strings in the
> path= statement.  But since the path= statement is passed to fnmatch(),
> which treats it as a file glob, it would be possible to construct two
> path statements that don't match but match the same set of files.  I
> don't think we can reasonably detect this situation, so it may be that
> the answer is "the first match found is used" and have that be the
> official stance.

I think we do need an "official stance" here.
glob is good for lots of things, but it is hard to say "everything except".
The best way to do that is to have a clear ordering with more general globs
later in the order.
   path=abcd  action=foo
   path=abc*  action=bar
   path=*     action=baz

So the last line doesn't really mean "do baz on everything" but rather
"do baz on everything else".

You could impose ordering explicitly with a priority number or a
"this domain takes precedence over that domain" tag, but I suspect
simple ordering in the config file is easiest and so best.

An important question to ask here though is whether people will want to
generate the "domain" lines automatically and if so, how we can make it hard
for people to get that wrong.
Inserting a line in the middle of a file is probably more of a challenge than
inserting a line with a specific priority or depends-on tag.

So before we get too much further down this path, I think it would be good to
have some concrete scenarios about how this functionality will actually be
put into effect.  I'd love to just expect people to always edit mdadm.conf to
meet their specific needs, but experience shows that is naive - people will
write scripts based on imperfect understanding, then share those scripts
with others....


> 
> > So, do you plan to make changes similar to incremental in assembly to serve DOMAIN?
> 
> I had not planned on it, no.  The reason being that assembly isn't used
> for hotplug.  I guess I could see a use case for this though in that if
> you called mdadm -As then maybe we should consult the DOMAIN entries to
> see if there are free drives inside of a DOMAIN listed as spare or grow
> and whether or not we have any degraded arrays while assembling that
> could use the drives.  Dunno if we want to do that though.  However, I
> think I would prefer to get the incremental side of things working
> first, then go there.
> 
> > Should an array be split (not assembled) if a domain paths are dividing array into two separate DOMAIN?
> 
> I don't think so.  Amongst other things, this would make it possible to
> render a machine unbootable if you had a type in a domain path.  I think
> I would prefer to allow established arrays to assemble regardless of
> domain path entries.
> 
> >>  I'm happy to rework the code to support it if there's a valid use
> >> case, but so far my design goal has been to have a path only appear in
> >> one domain, and to then perform the appropriate action based upon that
> >> domain.
> > What is then the purpose of metadata keyword?
> 
> Mainly as a hint that a given domain uses a specific type of metadata.
> 
> > My initial plan was to create a default configuration for a specific metadata, where user specifies actions 
> > but without paths letting metadata handler to use default ones.
> > In your description, I can see that the path are required.
> 
> Yes.  We already have a default action for all paths: incremental.  This
> is the same as how things work today without any new support.  And when
> you combine incremental with the AUTO keyword in mdadm.conf, you can
> control which devices are auto assembled on a metadata by metadata basis
> without the use of DOMAINs. 


>                               The only purpose of a domain then is to
> specify an action other than incremental for devices plugged into a
> given domain.

I like this statement.  It is simple and to the point and seems to capture
the key ideas.

The question is:  is it true? :-)
It is suggested that 'domain' also involved in spare-groups and could be used
to warn against, or disable, a 'create' or 'add' which violated policy.

So maybe:
  The purpose of a domain is to guide:
   - 'incremental' by specifying actions for hot-plug devices other than the
     default
   - 'create' and 'add' by identifying configurations that breach policy
   - 'monitor' by providing an alternate way of specifying spare-groups

It is a lot more wordy, but still seems useful.

While 'incremental' would not benefit from overlapping domains (as each
hotplugged device only wants one action), the other two might.

Suppose I want to configure array A to use only a certain set of drives,
and array B that can use any drive at all.  Then if we disallow overlapping
domains, there is no domain that describes the drives that B can be made from.

Does that matter?  Is it too hypothetical a situation?

Here is another interesting question.  Suppose I have two drive chassis, each
connected to the host by a fibre.  When I create arrays from all these drives,
I want them to be balanced across the two chassis, both for performance
reasons and for redundancy reasons.
Is there any way we can tell mdadm about this, possible through 'domains'.

This could be an issue when building a RAID10 (alternate across the chassis
is best) or when finding a spare for a RAID1 (choosing from the 'other'
chassis is best).

I don't really want to solve this now, but I do want to be sure that our
concept of 'domain' is big enough that we will be able to fit that sort of
thing into it one day.

Maybe a 'domain' is simply a mechanism to add tags to devices, and possibly
by implication to arrays that contain those devices.
The mechanism for resolving when multiple domains add conflicting tags to
the one device would be dependant on the tag.  Maybe first-wins.  Maybe
all are combined.

So we add an 'action' tag for --incremental, and the first wins (maybe)
We add a 'sparegroup' tag for --monitor
We add some other tag for balancing (share=1/2, share=2/2 ???)

I'm not sure how this fits with imposing platform constraints.
As platform constraints are closely tied to metadata types, it might be OK
to have a metadata-specific tags (imsm=???) and leave to details to the
metadata handler???

Dan: help me understand these platform constraints: what is the most complex
  constraint that you can think of that you might want to impose?

NeilBrown
