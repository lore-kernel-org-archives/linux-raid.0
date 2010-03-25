From: Neil Brown <neilb@suse.de>
Subject: Auto Rebuild on hot-plug
Date: Thu, 25 Mar 2010 11:35:43 +1100
Message-ID: <20100325113543.0e2124c5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.c>
Cc: linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids


Greetings.
 I find myself in the middle of two separate off-list conversations on the
 same topic and it has reached the point where I think the conversations
 really need to be unite and brought on-list.

 So here is my current understanding and thoughts.

 The topic is about making rebuild after a failure easier.  It strikes me as
 particularly relevant after the link  Bill Davidsen recently forwards to the
 list:

       http://blogs.techrepublic.com.com/opensource/?p=1368

 The most significant thing I got from this was a complain in the comments
 that managing md raid was too complex and hence error-prone.

 I see the issue as breaking down in to two parts.
  1/ When a device is hot plugged into the system, is md allowed to use it as
     a spare for recovery?
  2/ If md has a spare device, what set of arrays can it be used in if needed.

 A typical hot plug event will need to address both of these questions in
 turn before recovery actually starts.

 Part 1.

  A newly hotplugged device may have metadata for RAID (0.90, 1.x, IMSM, DDF,
  other vendor metadata) or LVM or a filesystem.  It might have a partition
  table which could be subordinate to or super-ordinate to other metadata.
  (i.e. RAID in partitions, or partitions in RAID).  The metadata may or may
  not be stale.  It may or may not match - either strongly or weakly -
  metadata on devices in currently active arrays.

  A newly hotplugged device also has a "path" which we can see
  in /dev/disk/by-path.  This is somehow indicative of a physical location.
  This path may be the same as the path of a device which was recently
  removed.  It might be one of a set of paths which make up a "RAID chassis".
  It might be one of a set of paths one which we happen to find other RAID
  arrays.

  Some how from all of that information we need to decide if md can use the
  device without asking, or possibly with a simple yes/no question, and we
  need to decide what to actually do with the device.

  Options for what to do with the device include:
    - write an MBR and partition table, then do something as below with
      each partition
    - include the device (or partition) in an array that it was previously
      part of, but from which it was removed
    - include the device or partition as a spare in a native-metadata array.
    - add the device as a spare to a vendor-metadata array

 Part 2.

   If we have a spare device and a degraded array we need to know if it is OK
   to add the device as a hot-spare to that array.
   Currently this is handled (for native metadata) by 'mdadm --monitor' and
   the  spare-groups tag in mdadm.conf.
   For vendor metadata, if the spare is already in the container then mdmon
   should handle the spare assignment, but if the spare is in a different
   container, 'mdadm --monitor' should move it to the right container, but
   doesn't yet.

   The "spare-group" functionality works but isn't necessarily the easiest
   way to express the configuration desires.  People are likely to want to
   specify how far a global spare can migrate using physical address: path.

   So for example you might specify a group of paths with wildcards with the
   implication that all arrays which contain disks from this group of paths
   are automatically in the same spare-group.


 Configuration and State

   I think it is clear that configuration for this should go in mdadm.conf.
   This would at least cover identifying groups of device by path and ways
   what is allowed to be done to those devices.
   It is possible that some configuration could be determined by inspecting
   the hardware directly.  e.g. the IMSM code currently looks for an Option
   ROM show confirms that the right Intel controller is present and so the
   system can boot from the IMSM device.  It is possible that other
   information could be gained this way so that the mdadm.conf configuration
   would not need to identify paths but alternately identify some
   platform-specific concept.

   The configuration would have to say what is permitted for hot-plugged
   devices:  nothing, re-add, claim-bare-only, claim-any-unrecognised
   The configuration would also describe mobility of spares across
   different device sets.

   This would add a new line type to mdadm.conf. e.g.
     DOMAIN or CHASSIS or DEDICATED or something else.
   The line would identify
         some devices by path or platform
         a metadata type that is expected here
         what hotplug is allows to do
         a spare-group that applies to all array which use devices from this
         group/domain/chassis/thing
         source for MBR?  template for partitioning?  or would this always
             be copied from some other device in the set if hotplug= allowed
             partitioning?

   State required would include
       - where devices have been recently removed from, and what they were in
         use for
       - which arrays are currently using which device sets, though that can
         be determined dynamically from inspecting active arrays.
       - ?? partition tables off any devices that are in use so if they are
         removed and an new device added the partition table can be
         replaced.

 Usability

  The idea of being able to pull out a device and plug in a replacement and
  have it all "just work" is a good one.  However I don't want to be too
  dependent on state that might have been saved from the old device.
  I would like to also be able to point to a new device which didn't exist
  before and say "use this".   mdadm would use the path information to decide
  which contain or set of drives was most appropriate, extract
  MBR/partitioning from one of those, impose it on the new device and include
  the device or partitions in the appropriate array.

  For RAID over partitions, this assumes a fairly regular configuration: all
  devices partitioned the same way, and each array build out of a set of 
  aligned partitions (e.g. /dev/sd[bcde]2 ).
  One of the strength of md is that you don't have to use such a restricted
  configuration, but I think it would be very hard to reliably "to the right
  thing" with an irregular set up (e.g. a raid1 over a 1T device and 2 500GB
  devices in a raid0).

  So I think we should firmly limit the range of configurations for which
  auto-magic stuff is done.  Vendor metadata is already fairly strongly
  defined.  We just add a device to the vendor container and let it worry
  about the detail.  For native metadata we need to draw a firm line.
  I think that line should be "all devices partitioned the same" but I
  am open to discussion.

  If we have "mdadm --use-this-device-however" without needing to know
  anything about pre-existing state, then a hot-remove would just need to
  record that the device was used by arrays X and Y. Then on hot plug we could
   - do nothing
   - do something if metadata on device allows
   - do use-this-device-however if there was a recent hot-remove of the device
   - always do use-this-device-however
  depending on configuration.

 Implementation

  I think we all agree that migrating spares between containers is best done
  by "mdadm --monitor".  It needs to be enhanced to intuit spare-group names
  from "DOMAIN" declarations, and to move spares between vendor containers.

  For hot-plug, hot-unplug I prefer to use udev triggers.  plug runs
    mdadm --incremental /dev/whatever
  which would be extended to do other clever things if allowed
  Unplug would run
     mdadm --force-remove /dev/whatever
  which finds any arrays containing the device (or partitions?) and
  fail/removes them and records the fact with a timestamp.

  However if someone has a convincing reason to build this functionality
  into  "mdadm --monitor" instead using libudev I am willing to listen.

  Probably the most important first step is to determine a configuration
  syntax and be sure it is broad enough to cover all needs.

  I'm thinking:
    DOMAIN path=glob-pattern metadata=type  hotplug=mode  spare-group=name

  I explicitly have "path=" in case we find there is a need to identify
  devices some other way - maybe by control vendor:device or some other
  content-based approach
  The spare-group name is inherited by any array with devices in this
  domain as long as that doesn't result it in having two different
  spare-group names.
  I'm not sure if "metadata=" is really needed.  If all the arrays that use
  these devices have the same metadata, it would be redundant to list it here.
  If they use different metadata ... then what?
  I guess two different DOMAIN lines could identify the same devices and 
  list different metadata types and given them different spare-group
  names.  However you cannot support hotplug of bare devices into both ...

  If it possible for multiple DOMAIN lines to identify the same device,
  e.g. by having more or less specific patterns. In this case the spare-group
  names are ignored if they conflict, and the hotplug mode used is the most
  permissive.

  hotplug modes are:
    none  - ignore any hotplugged device
    incr  - normal incremental assembly (the default).  If the device has
         metadata that matches an array, try to add it to the array
    replace - If above fails and a device was recently removed from this
         same path, add this device to the same array(s) that the old devices
         was part of
    include - If the above fails and the device has not recognisable metadata
         add it to any array/container that uses devices in this domain,
         partitioning first if necessary.
    force - as above but ignore any pre-existing metadata


  I'm not sure that all those are needed, or are the best names.  Names like
    ignore, reattach, rebuild, rebuild_spare
  have also been suggested.

  It might be useful to have a 'partition=type' flag to specify MBR or GPT ??


There, I think that just about covers everything relevant from the various
conversations.
Please feel free to disagree or suggest new use cases or explain why this
would not work or would not be ideal.
There was a suggestion that more state needed to be stored to support
auto-rebuild (detail of each device so they can be recovered exactly after a
device is pulled and a replacement added).  I'm not convinced of this but am
happy to hear more explanations.

Thanks,
NeilBrown
