Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76B0C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Jul 2022 21:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiGGVqj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiGGVqi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Jul 2022 17:46:38 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420D81BE81
        for <linux-raid@vger.kernel.org>; Thu,  7 Jul 2022 14:46:34 -0700 (PDT)
Received: from host86-160-229-11.range86-160.btcentralplus.com ([86.160.229.11] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o9ZKP-000BIy-5d;
        Thu, 07 Jul 2022 22:46:31 +0100
Message-ID: <33451435-9caa-a4ce-4a01-5d3af10f05e2@youngman.org.uk>
Date:   Thu, 7 Jul 2022 22:46:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] mdadm: Correct typos, punctuation and grammar in man
To:     "Grzonka, Mateusz" <mateusz.grzonka@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220707132620.28668-1-mateusz.grzonka@intel.com>
 <a7b1843b-1cc7-0b8c-a8ce-4fcdbeeb6a84@linux.intel.com>
Content-Language: en-GB
In-Reply-To: <a7b1843b-1cc7-0b8c-a8ce-4fcdbeeb6a84@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/07/2022 14:50, Grzonka, Mateusz wrote:
> Wol, could you review it please?
> 
> On 7/7/2022 3:26 PM, Mateusz Grzonka wrote:
>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>> ---
>>   mdadm.8.in | 142 ++++++++++++++++++++++++++---------------------------
>>   1 file changed, 71 insertions(+), 71 deletions(-)
>>
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index 0be02e4a..b9977d89 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -158,7 +158,7 @@ adding new spares and removing faulty devices.
>>   .B Misc
>>   This is an 'everything else' mode that supports operations on active
>>   arrays, operations on component devices such as erasing old 
>> superblocks, and
>> -information gathering operations.
>> +information-gathering operations.
Either is good. The second just feels a bit better.
>>   .\"This mode allows operations on independent devices such as 
>> examine MD
>>   .\"superblocks, erasing old superblocks and stopping active arrays.
>> @@ -231,12 +231,12 @@ mode to be assumed.
>>   .TP
>>   .BR \-h ", " \-\-help
>> -Display general help message or, after one of the above options, a
>> +Display a general help message or, after one of the above options, a
>>   mode-specific help message.
Ack. "a" and "the" are important in English, but often missing in other 
languages, so non-native people don't use them.
>>   .TP
>>   .B \-\-help\-options
>> -Display more detailed help about command line parsing and some commonly
>> +Display more detailed help about command-line parsing and some commonly
>>   used options.
As above, the second just feels better.
>>   .TP
>> @@ -266,7 +266,7 @@ the exact meaning of this option in different 
>> contexts.
>>   .TP
>>   .BR \-c ", " \-\-config=
>> -Specify the config file or directory.  If not specified, default 
>> config file
>> +Specify the config file or directory.  If not specified, the default 
>> config file
>>   and default conf.d directory will be used.  See
>>   .BR mdadm.conf (5)
>>   for more details.
Ack. As above, good.
>> @@ -345,8 +345,8 @@ last partition, if that partition starts on a 64K 
>> boundary.
>>   .el
>>   .IP "1, 1.0, 1.1, 1.2 default"
>>   Use the new version-1 format superblock.  This has fewer restrictions.
>> -It can easily be moved between hosts with different endian-ness, and a
>> -recovery operation can be checkpointed and restarted.  The different
>> +It can easily be moved between hosts with different endian-ness, and 
>> during a
>> +recovery operation checkpoint can be made, and recovery can be 
>> restarted. The different
Nack. The original is short and sweet, the replacement is wordy and 
doesn't feel right.
>>   sub-versions store the superblock at different locations on the
>>   device, either at the end (for 1.0), at the start (for 1.1) or 4K from
>>   the start (for 1.2).  "1" is equivalent to "1.2" (the commonly
>> @@ -379,7 +379,7 @@ When creating an array, the
>>   .B homehost
>>   will be recorded in the metadata.  For version-1 superblocks, it will
>>   be prefixed to the array n
ame.  For version-0.90 superblocks, part of
>> -the SHA1 hash of the hostname will be stored in the later half of the
>> +the SHA1 hash of the hostname will be stored in the latter half of the
>>   UUID.
Ack. These words are similar both in spelling and meaning, and easily 
confused ...
>>   When reporting information about an array, any array which is tagged
>> @@ -403,7 +403,7 @@ When
>>   .I mdadm
>>   needs to print the name for a device it normally finds the name in
>>   .B /dev
>> -which refers to the device and is shortest.  When a path component is
>> +which refers to the device and is the shortest.  When a path 
Ack. As above.
>> component is
>>   given with
>>   .B \-\-prefer
>>   .I mdadm
>> @@ -478,9 +478,9 @@ still be larger than any replacement.
>>   This option can be used with
>>   .B \-\-create
>> -for determining initial size of an array. For external metadata,
>> +for determining the initial size of an array. For external metadata,
Ack.
>>   it can be used on a volume, but not on a container itself.
>> -Setting initial size of
>> +Setting the initial size of
Ack.
>>   .B RAID 0
>>   array is only valid for external metadata.

You've missed a trick here - "Specify chunk size *in* kilobytes."

>> @@ -551,14 +551,14 @@ default when building an array with no 
>> persistent metadata is 64KB.
>>   This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
>>   RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
>> -of 2.  In any case it must be a multiple of 4KB.
>> +of 2.  In any case, it must be a multiple of 4KB.

This reads wrong. The grammar is correct either way, but combined with 
the 4KB requirement it just doesn't feel right at all.

"require the chunk size in KB to be a power of 2 and at least 4KB." The 
"multiple" is implied by that and not necessary.

>>   A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
>>   Megabytes, Gigabytes or Terabytes respectively.
>>   .TP
>>   .BR \-\-rounding=
>> -Specify rounding factor for a Linear array.  The size of each
>> +Specify the rounding factor for a Linear array.  The size of each
Ack.
>>   component will be rounded down to a multiple of this size.
>>   This is a synonym for
>>   .B \-\-chunk
>> @@ -673,7 +673,7 @@ signals 'far' copies
>>   (multiple copies have very different offsets).
>>   See md(4) for more detail about 'near', 'offset', and 'far'.
>> -The number is the number of copies of each datablock.  2 is normal, 3
>> +The number is the number of copies of each data block.  2 is normal, 3
Not at all sure about this. The original feels weird but more correct.
>>   can be useful.  This number can be at most equal to the number of
>>   devices in the array.  It does not need to divide evenly into that
>>   number (e.g. it is perfectly legal to have an 'n2' layout for an array
>> @@ -684,7 +684,7 @@ A bug introduced in Linux 3.14 means that RAID0 
>> arrays
>>   started using a different layout.  This could lead to
>>   data corruption.  Since Linux 5.4 (and various stable releases that 
>> received
>>   backports), the kernel will not accept such an array unless
>> -a layout is explictly set.  It can be set to
>> +a layout is explicitly set.  It can be set to
Ack.
>>   .RB ' original '
>>   or
>>   .RB ' alternate '.
>> @@ -760,13 +760,13 @@ or by selecting a different consistency policy with
>>   .TP
>>   .BR \-\-bitmap\-chunk=
>> -Set the chunksize of the bitmap.  Each bit corresponds to that many
>> +Set the chunk size of the bitmap.  Each bit corresponds to that many
Ack.
>>   Kilobytes of storage.
>> -When using a file based bitmap, the default is to use the smallest
>> -size that is at-least 4 and requires no more than 2^21 chunks.
>> +When using a file-based bitmap, the default is to use the smallest
>> +size that is at least 4 and requires no more than 2^21 chunks.
Ack.
>>   When using an
>>   .B internal
>> -bitmap, the chunksize defaults to 64Meg, or larger if necessary to
>> +bitmap, the chunk size defaults to 64Meg, or larger if necessary to
Ack.
>>   fit the bitmap into the available space.
>>   A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
>> @@ -840,7 +840,7 @@ can be used with that command to avoid the 
>> automatic resync.
>>   .BR \-\-backup\-file=
>>   This is needed when
>>   .B \-\-grow
>> -is used to increase the number of raid-devices in a RAID5 or RAID6 if
>> +is used to increase the number of raid devices in a RAID5 or RAID6 if
Ack.
>>   there are no spare devices available, or to shrink, change RAID level
>>   or layout.  See the GROW MODE section below on RAID\-DEVICES CHANGES.
>>   The file must be stored on a separate device, not on the RAID array
>> @@ -879,7 +879,7 @@ When creating an array,
>>   .B \-\-data\-offset
>>   can be specified as
>>   .BR variable .
>> -In the case each member device is expected to have a offset appended
>> +In the case each member device is expected to have an offset appended
Ack. You always use "a" before a consonant, and "an" before a vowel. The 
definition of consonant and vowel can sometimes be argued over - "h" and 
"y" are common causes of dissent.
>>   to the name, separated by a colon.  This makes it possible to recreate
>>   exactly an array which has varying data offsets (as can happen when
>>   different versions of
>> @@ -943,7 +943,7 @@ Insist that
>>   .I mdadm
>>   accept the geometry and layout specified without question.  Normally
>>   .I mdadm
>> -will not allow creation of an array with only one device, and will try
>> +will not allow the creation of an array with only one device, and 
Ack.
>> will try
>>   to create a RAID5 array with one missing drive (as this makes the
>>   initial resync work faster).  With
>>   .BR \-\-force ,
>> @@ -1004,7 +1004,7 @@ number added, e.g.
>>   If the md device name is in a 'standard' format as described in DEVICE
>>   NAMES, then it will be created, if necessary, with the appropriate
>>   device number based on that name.  If the device name is not in one 
>> of these
>> -formats, then a unused device number will be allocated.  The device
>> +formats, then an unused device number will be allocated.  The device
Ack.
>>   number will be considered unused if there is no active array for that
>>   number, and there is no entry in /dev for that number and with a
>>   non-standard name.  Names that are not in 'standard' format are only
>> @@ -1032,21 +1032,21 @@ then
>>   .B \-\-add
>>   can be used to add some extra devices to be included in the array.
>>   In most cases this is not needed as the extra devices can be added as
>> -spares first, and then the number of raid-disks can be changed.
>> -However for RAID0, it is not possible to add spares.  So to increase
>> +spares first, and then the number of raid disks can be changed.
>> +However, for RAID0 it is not possible to add spares.  So to increase
Ack. The comma is not necessary but it reads nicer. It breaks the text 
where a native speaker would break the speech.
>>   the number of devices in a RAID0, it is necessary to set the new
>>   number of devices, and to add the new devices, in the same command.
>>   .TP
>>   .BR \-\-nodes
>> -Only works when the array is for clustered environment. It specifies
>> +Only works when the array is for the clustered environment. It specifies
"For *a* clustered environment". You are not talking about a specific 
instance, but a general environment, so use the indefinite form, not the 
definite.
>>   the maximum number of nodes in the cluster that will use this device
>>   simultaneously. If not specified, this defaults to 4.
>>   .TP
>>   .BR \-\-write-journal
>>   Specify journal device for the RAID-4/5/6 array. The journal device
>> -should be a SSD with reasonable lifetime.
>> +should be an SSD with a reasonable lifetime.
Ack (imnsho - this is where we may have arguments because "S" is a 
consonant, but it's pronounced "ess" which begins with a vowel ...)
>>   .TP
>>   .BR \-\-symlinks
>> @@ -1055,15 +1055,15 @@ be 'no' or 'yes' and work with --create and 
>> --build.
>>   .TP
>>   .BR \-k ", " \-\-consistency\-policy=
>> -Specify how the array maintains consistency in case of unexpected 
>> shutdown.
>> +Specify how the array maintains consistency in case of an unexpected 
>> shutdown.
"Specify how the array maintains consistency in *the* case of an 
unexpected shutdown."
>>   Only relevant for RAID levels with redundancy.
>> -Currently supported options are:
>> +Currently, supported options are:
Nack. The comma changes the meaning, and here we do want the first 
version (although both are good English).
>>   .RS
>>   .TP
>>   .B resync
>>   Full resync is performed and all redundancy is regenerated when the 
>> array is
>> -started after unclean shutdown.
>> +started after an unclean shutdown.re-started after an unclean shutdown.
>>   .TP
>>   .B bitmap
>> @@ -1072,8 +1072,8 @@ Resync assisted by a write-intent bitmap. 
>> Implicitly selected when using
>>   .TP
>>   .B journal
>> -For RAID levels 4/5/6, journal device is used to log transactions and 
>> replay
>> -after unclean shutdown. Implicitly selected when using
>> +For RAID levels 4/5/6, the journal device is used to log transactions 
>> and replay
>> +after an unclean shutdown. Implicitly selected when using
Ack.
>>   .BR \-\-write\-journal .
>>   .TP
>> @@ -1241,8 +1241,8 @@ This can be useful if
>>   .B \-\-examine
>>   reports a different "Preferred Minor" to
>>   .BR \-\-detail .
>> -In some cases this update will be performed automatically
>> -by the kernel driver.  In particular the update happens automatically
>> +In some cases, this update will be performed automatically
Nack
>> +by the kernel driver.  In particular, the update happens automatically
Ack.
>>   at the first write to an array with redundancy (RAID level 1 or
>>   greater) on a 2.6 (or later) kernel.
If you read it out loud, does it feel like breaking at that point would 
improve comprehension? If you're not a native speaker it can be very 
hard to make the call. Or more importantly, would breaking at that point 
hinder comprehension (I'm thinking of the English translator, listening 
to a German speaker, and waiting for an interminable sentence to finish 
so he could put the verb in. For people who don't know the two 
languages, English puts the verb at the start, German puts it at the 
end, so a long German sentence in a speech is a nightmare to translate :-)

>> @@ -1282,7 +1282,7 @@ For version-1 superblocks, this involves 
>> updating the name.
>>   The
>>   .B home\-cluster
>>   option will change the cluster name as recorded in the superblock and
>> -bitmap. This option only works for clustered environment.
>> +bitmap. This option only works for the clustered environment.
Only works for *a* clustered environment.
>>   The
>>   .B resync
>> @@ -1319,7 +1319,7 @@ useful when the component device has changed 
>> size (typically become
>>   larger).  The version 1 metadata records the amount of the device that
>>   can be used to store data, so if a device in a version 1.1 or 1.2
>>   array becomes larger, the metadata will still be visible, but the
>> -extra space will not.  In this case it might be useful to assemble the
>> +extra space will not.  In this case, it might be useful to assemble the
Nack ... I just feel it flows better if you don't ... it's a tricky call.
>>   array with
>>   .BR \-\-update=devicesize .
>>   This will cause
>> @@ -1395,8 +1395,8 @@ This option should be used with great caution.
>>   .TP
>>   .BR \-\-freeze\-reshape
>> -Option is intended to be used in start-up scripts during initrd boot 
>> phase.
>> -When array under reshape is assembled during initrd phase, this option
>> +Option is intended to be used in start-up scripts during the initrd 
>> boot phase.
>> +When the array under reshape is assembled during the initrd phase,  >> this option
>>   stops reshape after reshape critical section is being restored. This 
>> happens
>>   before file system pivot operation and avoids loss of file system 
>> context.
>>   Losing file system context would cause reshape to be broken.

This entire section isn't actually comprehensible. What I *think* it is 
saying is

This option is intended to be used in start-up scripts during the initrd 
boot phase. When the array under reshape is assembled during the initrd 
phase, this option stops the reshape after the reshape-critical section 
has been restored. This happens before the file system pivot operation 
and avoids the loss of file system context. Losing the file system 
context would cause reshape to be broken.

NOTE I changed the tense of "is being". We have a past tense occurring 
after a continuous present, so something is being forced through a time 
warp.

>> @@ -1446,9 +1446,9 @@ re\-add a device that was previously removed 
>> from an array.
>>   If the metadata on the device reports that it is a member of the
>>   array, and the slot that it used is still vacant, then the device will
>>   be added back to the array in the same position.  This will normally
>> -cause the data for that device to be recovered.  However based on the
>> +cause the data for that device to be recovered.  However, based on the
Ack.
>>   event count on the device, the recovery may only require sections that
>> -are flagged a write-intent bitmap to be recovered or may not require
>> +are flagged as a write-intent bitmap to be recovered or may not require
flagged by a write-intent bitmap to be recovered, or may not
>>   any recovery at all.
>>   When used on an array that has no metadata (i.e. it was built with
That one was tricky. But it breaks neatly into sections, which feel 
better slightly separated. (A full stop brings you to a halt, ready to 
start again, a comma just introduces a pause between two independent 
sections that belong together. And if that seems a bit vague, sorry, 
that's language for you :-)

And can you look at the third paragraph of this section... I *think* it 
is trying to say

--re-add can also be accompanied by --update=devicesize. See the 
description of this option when used in Assemble mode for an explanation 
of its use.

Note also that the next few options seem to be missing a blank line 
above them.

>> @@ -1489,7 +1489,7 @@ Add a device as a spare.  This is similar to
>>   except that it does not attempt
>>   .B \-\-re\-add
>>   first.  The device will be added as a spare even if it looks like it
>> -could be an recent member of the array.
>> +could be a recent member of the array.
Ack.
>>   .TP
>>   .BR \-r ", " \-\-remove

>> @@ -1506,12 +1506,12 @@ and names like
>>   .B set-A
>>   can be given to
>>   .BR \-\-remove .
>> -The first causes all failed device to be removed.  The second causes
>> +The first causes all failed devices to be removed.  The second causes
Ack
>>   any device which is no longer connected to the system (i.e an 'open'
>>   returns
>>   .BR ENXIO )
>>   to be removed.
>> -The third will remove a set as describe below under
>> +The third will remove a set as described below under
Ack
>>   .BR \-\-fail .
>>   .TP
>> @@ -1528,7 +1528,7 @@ For RAID10 arrays where the number of copies 
>> evenly divides the number
>>   of devices, the devices can be conceptually divided into sets where
>>   each set contains a single complete copy of the data on the array.
>>   Sometimes a RAID10 array will be configured so that these sets are on
>> -separate controllers.  In this case all the devices in one set can be
>> +separate controllers.  In this case, all the devices in one set can be
Ack
>>   failed by giving a name like
>>   .B set\-A
>>   or

>> @@ -1560,7 +1560,7 @@ devices.  The devices listed after
>>   .B \-\-with
>>   will be preferentially used to replace the devices listed after
not sure about "be preferentially" or "preferentially be". The latter is 
probably correct, because you've stuck an adverb in the middle of a 
compound verb which is "not a good thing" :-)
>>   .BR \-\-replace .
>> -These device must already be spare devices in the array.
>> +These devices must already be spare devices in the array.
Ack
>>   .TP
>>   .BR \-\-write\-mostly

>> @@ -1584,7 +1584,7 @@ the device is found or <slot>:missing in case 
>> the device is not found.
>>   .TP
>>   .BR \-\-add-journal
>>   Add journal to an existing array, or recreate journal for RAID-4/5/6 
Add a journal to an existing array, or recreate the journal for a RAID

A good example of when to use "a" or "the" - because the first journal 
doesn't exist you use the indefinite article "a". Because you are 
referring to a specific journal that should exist in the second case, 
you use the definite article "the".
>> array
>> -that lost a journal device. To avoid interrupting on-going write 
>> opertions,
>> +that lost a journal device. To avoid interrupting ongoing write 
>> operations,
Ack
>>   .B \-\-add-journal
>>   only works for array in Read-Only state.

>> @@ -1643,7 +1643,7 @@ Print details of the platform's RAID 
>> capabilities (firmware / hardware
>>   topology) for a given metadata format. If used without argument, mdadm
without *an* argument
>>   will scan all controllers looking for their capabilities. Otherwise, 
>> mdadm
>>   will only look at the controller specified by the argument in form 
argument in the form
>> of an
>> -absolute filepath or a link, e.g.
>> +absolute file path or a link, e.g.
absolute filename

That's clearly what was meant. "path" implies a directory, which I guess 
doesn't make sense here.
>>   .IR /sys/devices/pci0000:00/0000:00:1f.2 .
>>   .TP

>> @@ -1752,7 +1752,7 @@ doesn't appear to be valid.
>>   .B Note:
>>   Be careful to call \-\-zero\-superblock with clustered raid, make sure
careful when calling

Oh the joys of English having three (or more?) different present tenses 
when other languages mostly have just the one ...
>> -array isn't used or assembled in other cluster node before execute it.
>> +the array isn't used or assembled in another cluster node before 
Ack
>> executing it.
>>   .TP
>>   .B \-\-kill\-subarray=

>> @@ -1799,7 +1799,7 @@ For each md device given, or each device in 
>> /proc/mdstat if
>>   is given, arrange for the array to be marked clean as soon as possible.

>>   .I mdadm
>>   will return with success if the array uses external metadata and we
This bit doesn't read quite right. What does mdadm return if the array 
uses external metadata and the wait fails?

>> -successfully waited.  For native arrays this returns immediately as the
>> +successfully waited.  For native arrays, this returns immediately as the
Ack
>>   kernel handles dirty-clean transitions at shutdown.  No action is taken
>>   if safe-mode handling is disabled.

>> @@ -1970,7 +1970,7 @@ Usage:
>>   .PP
>>   This usage assembles one or more RAID arrays from pre-existing 
>> components.
>>   For each array, mdadm needs to know the md device, the identity of the
>> -array, and a number of component-devices.  These can be found in a 
>> number of ways.
>> +array, and a number of component devices.  These can be found in a 
Ack.

But I have a problem - "a number of" is almost certainly wrong. It's 
either "the" or "some of the". "some of the" implies mdadm will find the 
rest on its own, "the" implies that you have to provide a list of all of 
them (or none). I'd  be inclined to use "the" so it's consistent.

Then look at the entire section and see if we can improve it.
>> number of ways.
>>   In the first usage example (without the
>>   .BR \-\-scan )

>> @@ -2010,7 +2010,7 @@ The config file is only used if explicitly named 
>> with
>>   .B \-\-config
>>   or requested with (a possibly implicit)
>>   .BR \-\-scan .
>> -In the later case, default config file is used.  See
>> +In the latter case, the default config file is used.  See
Ack
>>   .BR mdadm.conf (5)
>>   for more details.

>> @@ -2051,11 +2051,11 @@ itself.
>>   In Linux kernels prior to version 2.6.28 there were two distinctly
"distinctly different". A bit OTT and it doesn't feel quite right. "two 
distinct types" is just simpler and cleaner.
>>   different types of md devices that could be created: one that could be
>>   partitioned using standard partitioning tools and one that could not.
>> -Since 2.6.28 that distinction is no longer relevant as both type of
>> +Since 2.6.28 that distinction is no longer relevant as both types of
Ack
>>   devices can be partitioned.
>>   .I mdadm
>>   will normally create the type that originally could not be partitioned
>> -as it has a well defined major number (9).
>> +as it has a well-defined major number (9).
Ack
>>   Prior to 2.6.28, it is important that mdadm chooses the correct type
>>   of array device to use.  This can be controlled with the

>> @@ -2102,7 +2102,7 @@ an array, and if the superblock is tagged as 
>> belonging to the given
>>   home host, it will automatically choose a device name and try to
>>   assemble the array.  If the array uses version-0.90 metadata, then the
>>   .B minor
>> -number as recorded in the superblock is used to create a name in
>> +number, as recorded in the superblock, is used to create a name in
Nack. The bit you've split out belongs with "number" so shouldn't really 
be separated. Tricky call I agree but to me it's obvious.
>>   .B /dev/md/
>>   so for example
>>   .BR /dev/md/3 .

>> @@ -2134,8 +2134,8 @@ for further details.
>>   Note: Auto assembly cannot be used for assembling and activating some
>>   arrays which are undergoing reshape.  In particular as the
>>   .B backup\-file
>> -cannot be given, any reshape which requires a backup-file to continue
>> -cannot be started by auto assembly.  An array which is growing to more
>> +cannot be given, any reshape which requires a backup file to continue
Ack
>> +cannot be started by the auto assembly.  An array which is growing to 
Nack. It's definitely not "the" because auto-assembly is generic, but I 
can't really explain why it's not an "an". It just isn't ...
>> more
>>   devices and has passed the critical section can be assembled using
>>   auto-assembly.
Note also the inconsistent use of "auto assembly" and "auto-assembly". 
You'll notice I used auto-assembly, but whichever you use change it to 
be consistent.

>> @@ -2242,7 +2242,7 @@ When creating a partition based array, using
>>   .I mdadm
>>   with version-1.x metadata, the partition type should be set to
>>   .B 0xDA
>> -(non fs-data).  This type selection allows for greater precision since
>> +(non fs-data).  This type of selection allows for greater precision 
Ack
>> since
>>   using any other [RAID auto-detect (0xFD) or a GNU/Linux partition 
>> (0x83)],
>>   might create problems in the event of array recovery through a live 
>> cdrom.

>> @@ -2258,7 +2258,7 @@ when creating a v0.90 array will silently 
>> override any
>>   setting.
>>   .\"If the
>>   .\".B \-\-size
>> -.\"option is given, it is not necessary to list any component-devices 
>> in this command.
>> +.\"option is given, it is not necessary to list any component devices 
Ack
>> in this command.
>>   .\"They can be added later, before a
>>   .\".B \-\-run.
>>   .\"If no

>> @@ -2272,7 +2272,7 @@ requested with the
>>   .B \-\-bitmap
>>   option or a different consistency policy is selected with the
>>   .B \-\-consistency\-policy
>> -option. In any case space for a bitmap will be reserved so that one
>> +option. In any case, space for a bitmap will be reserved so that one
Ack
>>   can be added later with
>>   .BR "\-\-grow \-\-bitmap=internal" .

>> @@ -2322,7 +2322,7 @@ will firstly mark
>>   as faulty in
>>   .B /dev/md0
>>   and will then remove it from the array and finally add it back
>> -in as a spare.  However only one md array can be affected by a single
>> +in as a spare.  However, only one md array can be affected by a single
Ack
>>   command.
>>   When a device is added to an active array, mdadm checks to see if it

>> @@ -2468,13 +2468,13 @@ If the device contains RAID metadata, a file 
>> will be created in the
>>   .I directory
>>   and the metadata will be written to it.  The file will be the same
>>   size as the device and have the metadata written in the file at the
>> -same locate that it exists in the device.  However the file will be 
>> "sparse" so
>> +same locate that it exists in the device.  However, the file will be 
same location as it
Ack
>> "sparse" so
>>   that only those blocks containing metadata will be allocated. The
>>   total space used will be small.
>> -The file name used in the
>> +The filename used in the
Ack
>>   .I directory
>> -will be the base name of the device.   Further if any links appear in
>> +will be the base name of the device.   Further, if any links appear in
Furthermore
Ack
>>   .I /dev/disk/by-id
>>   which point to the device, then hard links to the file will be created
>>   in

>> @@ -2494,7 +2494,7 @@ This is the reverse of
>>   will locate a file in the directory that has a name appropriate for
>>   the given device and will restore metadata from it.  Names that match
>>   .I /dev/disk/by-id
>> -names are preferred, however if two of those refer to different files,
>> +names are preferred. However, if two of those refer to different files,
Nack. It all belongs together, so don't break the sentence.
>>   .I mdadm
>>   will not choose between them but will abort the operation.

>> @@ -2576,7 +2576,7 @@ and if the destination array has a failed drive 
>> but no spares.
>>   If any devices are listed on the command line,
>>   .I mdadm
>> -will only monitor those devices.  Otherwise all arrays listed in the
>> +will only monitor those devices.  Otherwise, all arrays listed in the
I'd actually combine the sentences - "those devices, otherwise all".
>>   configuration file will be monitored.  Further, if
>>   .B \-\-scan
>>   is given, then any other md devices that appear in

>> @@ -2633,10 +2633,10 @@ check, repair). (syslog priority: Warning)
>>   .BI Rebuild NN
>>   Where
>>   .I NN
>> -is a two-digit number (ie. 05, 48). This indicates that rebuild
>> +is a two-digit number (ie. 05, 48). This indicates that the rebuild
>>   has passed that many percent of the total. The events are generated
>>   with fixed increment since 0. Increment size may be specified with
>> -a commandline option (default is 20). (syslog priority: Warning)
>> +a command-line option (default is 20). (syslog priority: Warning)
>>   .TP
>>   .B RebuildFinished

Where NN is a two-digit number (eg. 05, 48). This  indicates
that the rebuild has reached that percentage of the total. The
events are generated at a fixed increment from 0. The increment
size  may be specified with a command-line option (the default is
20). (syslog priority: Warning)

>> @@ -2744,7 +2744,7 @@ When
>>   detects that an array in a spare group has fewer active
>>   devices than necessary for the complete array, and has no spare
>>   devices, it will look for another array in the same spare group that
>> -has a full complement of working drive and a spare.  It will then
>> +has a full complement of a working drive and a spare.  It will then
has a full complement of working drives and a spare.
>>   attempt to remove the spare from the second drive and add it to the
remove the spare from the second *array*
>>   first.
>>   If the removal succeeds but the adding fails, then it is added back to

>> @@ -2762,7 +2762,7 @@ array.
>>   For this to work, the kernel must support the necessary change.
>>   Various types of growth are being added during 2.6 development.

Given that 2.6 was a long time ago, can we move this into the past 
tense? Along the lines "During the 2.6 era the following changes were 
added ..."

At least it tells you it's 2.6 era - that's one of my pet peeves when 
you don't have a clue as to timescales and stuff is either bleeding edge 
or ancient history, but there's no context to tell you!

>> -Currently the supported changes include
>> +Currently, the supported changes include
Ack, but see above...
>>   .IP \(bu 4
>>   change the "size" attribute for RAID1, RAID4, RAID5 and RAID6.
>>   .IP \(bu 4

>> @@ -2821,7 +2821,7 @@ after growing, or to reduce its size

Just above here in the first para of SIZE CHANGES, I'd change it as 
follows - " If all the small drives in an  arrays  are,  *over time*, 
removed  and replaced with larger drives,"

>>   .B prior
>>   to shrinking the array.
>> -Also the size of an array cannot be changed while it has an active
>> +Also, the size of an array cannot be changed while it has an active
Ack
>>   bitmap.  If an array has a bitmap, it must be removed before the size
>>   can be changed. Once the change is complete a new bitmap can be 
>> created.

Should this be updated to cover journals? Journals are now recommended 
rather than bitmaps, I believe.

>> @@ -2901,7 +2901,7 @@ long time.  A
>>   is required.  If the array is not simultaneously being grown or
>>   shrunk, so that the array size will remain the same - for example,
>>   reshaping a 3-drive RAID5 into a 4-drive RAID6 - the backup file will
>> -be used not just for a "cricital section" but throughout the reshape
>> +be used not just for a "critical section" but throughout the reshape
Ack. But to what extent is this now true? I was under the impression 
that - especially with superblock 1.2, that that 4K was used to store 
the critical section. As such there is no need for a backup file, which 
makes reshaping a lot more robust.
>>   operation, as described below under LAYOUT CHANGES.
>>   .SS CHUNK-SIZE AND LAYOUT CHANGES

>> @@ -2919,7 +2919,7 @@ slowly.
>>   If the reshape is interrupted for any reason, this backup file must be
>>   made available to
>>   .B "mdadm --assemble"
>> -so the array can be reassembled.  Consequently the file cannot be
>> +so the array can be reassembled.  Consequently, the file cannot be
>>   stored on the device being reshaped.
> 
Ack

That was a marathon! :-)

If you want to revert my nacks, you can add a reviewed - "Wol 
<anthony@youngman.org.uk>" (I use my proper email name, not assorted 
aliases, for real code ...)

Stick the other changes in a new patch, and I'll review those.

Cheers,
Wol
