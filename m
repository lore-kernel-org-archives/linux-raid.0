From: thomas62186218@aol.com
Subject: Re: RAID 0 md device still active after pulled drive
Date: Sun, 19 Oct 2008 20:56:53 -0400
Message-ID: <8CB0065E0C4DA23-1154-252F@WEBMAIL-DY12.sysops.aol.com>
References: <8CAFECFAC51849A-1CD4-454@FWM-D03.sysops.aol.com> <18683.53845.702858.972766@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18683.53845.702858.972766@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thank you for the response and clarification. Regarding where mdadm 
reported a drive failure, it came from mdadm --monitor (see points 2 
and 3 in my original email, pasted below):

------------------------
2) Then I monitor the md device.

mdadm --monitor -1 /dev/md2

3) Then I pull out a hard drive from the RAID 0 out of the system. At 
this point, I expect md device to become inactive.

DeviceDisappeared on /dev/md2 Wrong-Level
------------------------

So, mdadm acknowledges a device has disappeared from the RAID 0 md 
(/dev/md2). This of course means the RAID 0 must be inactive. So, there 
is a mismatch here in mdadm's reporting. It reports the drive failure, 
but does not report the corresponding RAID 0 failure.

For consistency, my recommendation would be therefore be to have mdadm 
report the array inactive at this point as well. Perhaps this is a 
special case for RAID 0, but I also think it is worth it to have mdadm 
try a little harder to report correctly, rather than not acknowledging 
the md failure at all.

Best regards,
-Thomas


-----Original Message-----
From: Neil Brown <neilb@suse.de>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Sun, 19 Oct 2008 5:35 pm
Subject: Re: RAID 0 md device still active after pulled drive










On Friday October 17, thomas62186218@aol.com wrote:
> Hi All,
>
> I have run into a most unusual behavior, where mdadm reports a RAID 0
> array that is missing a drive as "Active".

Not unusual at all.  mdadm has always behaved this way.

There is nothing that 'md' can ever do about a failed drive in a
raid0, so it doesn't bother doing anything.  At all.
As far as md is concerned, the drive is still an active part of the
array.  It will still try to send appropriate IO requests to that
device.  If they fail (e.g. because the device doesn't actually
exist), then md will send that error message back.
>
>
> Conclusion: Why does mdadm report a drive failure on RAID 0 but not
> make the md device as Inactive or otherwise failed?

where exactly did "mdadm report a drive failure" on the RAID0 ??


As always,  if you think the documentation could be improved to reduce
the chance of this sort of confusion, or if the output of mdadm could
make something more clear, I am open to constructive suggestions (and
patches).

NeilBrown





