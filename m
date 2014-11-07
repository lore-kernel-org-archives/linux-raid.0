From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 6 (containing LUKS dm-crypt) recovery help.
Date: Fri, 7 Nov 2014 14:22:59 +0000
Message-ID: <21596.54723.487775.652906@tree.ty.sabi.co.uk>
References: <545C5C9D.9000309@retard.io>
	<21596.40429.244605.398712@tree.ty.sabi.co.uk>
	<545CAFA8.2030602@retard.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545CAFA8.2030602@retard.io>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
>> But assuming the above is somewhat reliable there is an
>> "interesting" situation: in "21488638704 blocks" the number
>> 21,488,638,704 is not a whole multiple of 9:
>>=20
>> $ factor 21488638704
>> 21488638704: 2 2 2 2 3 13 1801 19121
[ ... ]
>> If you went to the lengths to write 'dd' expressions, you
>> might as well have saved the output of '--examine'. Perhaps
>> you did, but if you did not attach that output to your
>> request for help it would be rather "stunning".
[ ... ]
>> Both numbers don't match. They are *slightly* different. In
>> particular it is rather strange that the "Used Dev Size" is
>> different. How is that possible? Have the disks shrunk a
>> little in the meantime? :-)

> Yes, I saved the -E/--examine information, "just in case". :-)

But without sending it with your request for help: rather
"stunning".

> [ ... ] some disks have a 272 offset, while most others have a
> 2048 offset, [ ... ] Did older mdadm builds on 12.04 LTS ever
> use offsets of 272, rather than 2048?

Given what '--examine' reports exactly where this came from does
not matter a lot. What matters is this note (in a well written
page!):

  https://raid.wiki.kernel.org/index.php/RAID_Recovery
  =ABRecreating an array
  When an array is created, superblocks are written to the drive
  and according to the defaults of mdadm, a certain area of the
  drive is now considered "data area".
  The data areas (that might or might not be correct) are not
  written to, *provided* the array is created in degraded mode;
  that is with a 'missing' device.
  If the wrong superblock version is chosen, wrong data offset
  (internal default value which has changed over time in mdadm),
  chunk size (also value that has changed over time), then the
  data area will not match what was previously on the drives.
  The md superblock might have overwritten part of your data.
  Use with caution!=BB

You can try to recreate the MD set superblocks specifying the
right data offset and member size for each member, as given by
the '--examine' outputs. Google knows how...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
