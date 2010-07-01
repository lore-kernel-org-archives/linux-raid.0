From: Neil Brown <neilb@suse.de>
Subject: A policy frame work for mdadm (incorporating domains and hotplug
 and such)
Date: Thu, 1 Jul 2010 16:50:07 +1000
Message-ID: <20100701165007.4d0d51f7@notabene.brown>
References: <66C59AD0932712458090B447266D638CD69A3E95@irsmsx504.ger.corp.intel.com>
	<20100512070231.17342f29@notabene.brown>
	<4BE9D7DC.6000306@intel.com>
	<20100512132624.7a189995@notabene.brown>
	<4BEAF416.5050509@intel.com>
	<66C59AD0932712458090B447266D638CD6A81248@irsmsx504.ger.corp.intel.com>
	<4BEC941A.8070508@intel.com>
	<905EDD02F158D948B186911EB64DB3D11E33E9DE@irsmsx503.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638CD6D80FFF@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246FDA55FA48@irsmsx504.ger.corp.intel.com>
	<20100629113727.197a2002@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5235D9@irsmsx503.ger.corp.intel.com>
	<4C2B97E3.2080309@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C2B97E3.2080309@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,
 I figured it was time to make a firm decision on what "domains" and related
 things would look like in mdadm.  In all the discussions so far I have just
 been making suggestions and exploring possibilities and wandering around the
 edges of the issue.  But that cannot last forever as there is need for some
 certainty.

 I had a read through Doug's patch set and Przemyslaw's and Anna's work on
 top of that and there were certain aspects of what I saw that I didn't
 like.
 In particular the model of what a 'domain' was seems to keep changing, first
 growing special cases for partitions, and then growing subsets (which I admit
 I didn't completely understand).  When something grows and changes like that
 so quickly there is a very real possibility that the final result won't meet
 the original needs any more.

 I think we need to start with something that is *right* - at least as far as
 it goes.  Refinements that are predictable are ok, but structural changes
 aren't.

 So here is my concrete proposal on how these things will work.  I have
 already started implementing it, which shows that I'm fairly committed to
 this and would need a very strong argument for significant change to happen.


 The first step is to forget about domains.  We will come back to them later
 as they are important and useful.  But they are not central and we won't be
 starting there.  So forget them.  (Forget what? I don't remember anything...)

 What we need is a policy framework, for encoding policy about the various
 automatic actions that mdadm performs.  We already have bits of policy like
 the spare-group tag (which guides automatic spare migration) and the 'auto'
 mdadm.conf line (which guides automatic assembly).  However that is all
 ad-hoc and as the amount of policy increases, the amount of interaction
 increases so we need a unifying platform.  That is where we need to start.

 So point 1 is that we need a policy framework.

 Point 2 is that policy revolves primarily around devices (rather than
 arrays) and to a lesser extent around metadata types.
 It is devices that are migrated, devices that arrays are built from, devices
 that are automatically made into spares etc.
 Metadata types often encode some specific policy in the metadata, so they
 need some fairly strong role in the policy framework too.  Often the
 metadata type is like a parameter to a policy.  "You can incorporate this
 device in any imsm array".

 So Abstraction 1 is a "Policy statement".

 A policy statement applies to a particular device, possibly in the context
 of a particular metadata, and asserts that a particular name has a
 particular value.
     action=spare (ddf1)
 might be a policy statement about a device.  It says that where ddf1
 metadata is involved, the device can be made a hot-spare when it is
 hot-plugged.
     auto=homehost (0.90)
 might be another which says that auto-assembly may use a non-disambiguated
 name (no trailing _NN) when assembling this device into a metadata=0.90
 array providing the homehost information in the metadata matches this host.

 A statement might not have any metadata type associated.
     action=ignore
 applies irrespective of metadata type.

 The policy names that I currently envisage are:

   action=  ignore, include, spare, force-spare

     which covers the hotplug actions that --incremental might perform.

   auto=  yes, homehost, no
 
     which covers the functionality currently in the AUTO mdadm.conf line

   domain=  arbitrary-string

     This provides the 'domain' isolation functionality.
     The semantics I have in mind (and the precise details here are fairly
     important so this cannot be changed lightly) are:
       A device can have a number of domains, possibly from various sources.
       An array can have a number of domains, from the devices plus from
       spare-group

      A device may be attached to an array if all of the domains of the device
      are also domains of the array.  The array may have extra domains.  The
      device may not.

      This requires that if there are overlapping domains, they must properly
      nest. i.e. the intersection of two domains must be empty, or one of the
      domains.  It might make sense to have a domain 'global' which all
      devices have, and some other domains which just subsets have.

  There is probably room for other policies like whether to start an
  incrementally assembled degraded array early, or wait until it is not
  degraded.  Maybe some policy of handling "prodigal device" situations where
  two halfs of a mirror both this they are "it" and the other is "not".

By now Doug (hope your back is feeling better) will have noticed that
partitions haven't been mentioned yet.  So it is time for them.

Point 3: partitions become a new metadata type (or types).

If we want mdadm to ensure there is a MBR partition table on a device, then
provide a policy statement like
   action=spare (mbr)

so if the device doesn't have recognised metadata, mdadm configures it as a
spare of type mdr, getting the table from some compatible pre-existing device.
There is probably room to refine this to get the table from a file like
Doug's patches aimed to.  That wouldn't be my first preference as it requires
extra configuration, but it might be necessary.  That would require adding
some sort of argument to each policy statement, they become
  name = value (metadata) other-arguments
I'd rather keep that to a very minimum though.


Note that the above syntax is all abstract syntax.  It reflects the internal
data structures, but not necessarily the way that policy will be expressed to
mdadm.  For that we need to start with some concrete syntax for mdadm.conf
So:

  Point 4:  policy is specified in mdadm.conf by "POLICY" lines (aka policy
  rules)

   A policy line contains match words, assignment words, and metadata words.
     match words are name=value  or possibly  name==value - haven't decided
               yet.
     assignment words are name=value (or name:=value ... probably not)
     metadata words are "metadata=foo"

   A device matches a policy line if, for each match name that appears, the
   device matches at least one of the values.
   So if we have
              POLICY a==1 a==2 b==3 b==4

   then for a device to match it must have an 'a' or 1 or 2, and a 'b' of
   3 or 4, but it doesn't matter what the device has for 'c'.

   One device may match multiple POLICY lines and if it does so, it
   accumulates all the assigned words.  The ordering of policy lines is
   irrelevant to the end result.  For this to work we might need to add
   a "word!=value" - I hope not, but it wouldn't be a big problem.


   If a device matches a policy line then a separate policy statement is
   created combining each assignment word with each metadata word (if there
   are any).  This list of policy statements is added to the device's policy.

 Sometimes policy is very metadata dependent so:

 Point 5: policy can be specified by the metadata handler too.

   If a device is found to have metadata on it, then when that metadata is
   loaded (->load_super())  it might add some policy statements to the
   device.  If it does they will all be in the context of the relevant
   metadata type.  This will probably include 'domain' assignments to restrict
   spare migration.

 But wait, there's more

 Point 6:  We probably have platform policy too. I'm not really sure what
 this will involve, and what if anything needs to be explicit.  Maybe just

     platform-policy  imsm

 in mdadm.conf tell mdadm to query the platform and deduce some policy
 statements or police rules.

 There is a strong pattern that when a set of devices is partitioned, all the
 '1' partitions go in one array, all the '2' partitions in another etc.
 It might be useful to have config-file support for this pattern, so a
 possible config file line would be:

    partition-policy  path=foo domain=bar

 which effectively makes multiple policy lines each of which has '-partNN'
 added to all 'path' values and all 'domain' values.  But I'm getting ahead
 of myself...

 The 'match' names that I imagine are:
    path=   which is given a 'glob' pattern to match against the path name
               from /dev/disk/by-path/
    type=   which is either 'disk' or 'partition'

 We could also have size=  which uses the standardised disk sizes so it
 would be easy to say that all 2GB devices only migrate to arrays with 2GB
 devices in them.


So: given a device we extract a bunch of policy statements from various
sources.  Now we need to know how to apply those policy statements in
different situations.  There are various contexts where we need to review
policy.

A/ When considering adding a device to an array.
   This can happen at hot-plug either because the device looked like
   a member of the array, or because the device is being added as a new
   spare.

   The primary policy information here is 'domain'.
   We extract a list of domains that the device is in which are specific
   to the metadata of the array (or are not metadata-specific)

   We also get a list of domains for the array by extracting
   a similar list for each device and including any spare-group
   from mdadm.conf

   Then we check if the set of domains for the device is a subset of the set
   of domains for the array.  If it is (and is non-empty), the addition is
   allowed.  If it isn't then the addition probably isn't allow, though we
   might invent some other policy like "no-strict-domains", or assert that
   domains don't apply when the user explicitly makes a request.  or uses
   --force.  Or something.

   This might have some variation depending on whether the 'add this to an
   array' came from --create or --assemble or --add or --re-add or
   --incremental or --monitor doing spare migration.
   My point at the moment isn't to give the entire algorithm but the show how
   the policy framework would inform that algorithm.

B/ when considering what to do with a device that has been passed to
    --incremental.

   For this we need to
       1/ identify an array, and hence a metadata type
       2/ find the 'action' policy for the device with that metadata type.
       3/ if there are more than one, fail
       4/ if the one is 'ignore' do nothing
       5/ if 'A' above says we cannot add this device, then give up
       6/ consider which of 'include', 'spare', 'force-spare' might apply
          here.....

   If the device has recognisable metadata, which identifies an array, then
   the array identified in step 1 is just that array.
   If the device does not have recognisable metadata, then we consider 
   each array in turn (though we might optimise out some easy cases like
   if all metadatas say 'ignore' then don't bother listing arrays).

   If multiple arrays all allow the device to be added, we would need to
   chose the first which is degraded (unless we invented some other policy).


So this is how I want these things to work, and this is what I'm going to be
coding.  I should have the basic framework in place early next week (assuming
no major interruptions) at which point I'll make the code available.

The part of this that I'm least confident of is assigning domains to arrays.
Extracting a list of policy statements for each device sounds a bit
cumbersome.  Maybe if I cache enough bits of it, it will work nicely.

Comments, as always, are most welcome.

Thanks,
NeilBrown
