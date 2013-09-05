From: Andreas Baer <synthetic.gods@gmail.com>
Subject: Re: Update to mdadm V3.2.5 => RAID starts to recover (reproducible)
Date: Thu, 5 Sep 2013 17:22:26 +0200
Message-ID: <CAE65G7=qqcUVSHTJOczLCqAAjYgLtf02s-RpKzvD24NT2-q5ZA@mail.gmail.com>
References: <CAE65G7kMP2rFLGuO1rfsFp7V-rHGz-3K+VWuLMZqmGUPANyqcQ@mail.gmail.com>
	<20130826155202.7a11dff5@notabene.brown>
	<CAE65G7kb_xveCrzqedbkFUc=OUh-KDJ-K58SrmTWeGhgkN1vEQ@mail.gmail.com>
	<20130902113534.34f434f3@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c37be454f76a04e5a47d20
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130902113534.34f434f3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--001a11c37be454f76a04e5a47d20
Content-Type: text/plain; charset=ISO-8859-1

On 9/2/13, NeilBrown <neilb@suse.de> wrote:
> On Thu, 29 Aug 2013 11:55:09 +0200 Andreas Baer <synthetic.gods@gmail.com>
> wrote:
>
>> On 8/26/13, NeilBrown <neilb@suse.de> wrote:
>> > On Thu, 22 Aug 2013 15:20:06 +0200 Andreas Baer
>> > <synthetic.gods@gmail.com>
>> > wrote:
>> >
>> >> Short description:
>> >> I've discovered a problem during re-assembly of a clean RAID. mdadm
>> >> throws one disk out because this disk apparently shows another disk as
>> >> failed. After assembly, RAID starts to recover on existing spare disk.
>> >>
>> >> In detail:
>> >> 1. RAID-6 (Superblock V0.90.00) created with mdadm V2.6.4 and with 7
>> >> active disks and 1 spare disk (disk size: 1 TB), fully synced and
>> >> clean.
>> >> 2. RAID-6 stopped and re-assembled with mdadm V3.2.5, but during that
>> >> one disk is thrown out.
>> >>
>> >> Manual assembly command for /dev/md0, relevant partitions are
>> >> /dev/sd[b-i]1:
>> >> # mdadm --assemble --scan -vvv
>> >> mdadm: looking for devices for /dev/md0
>> >> mdadm: no RAID superblock on /dev/sdi
>> >> mdadm: no RAID superblock on /dev/sdh
>> >> mdadm: no RAID superblock on /dev/sdg
>> >> mdadm: no RAID superblock on /dev/sdf
>> >> mdadm: no RAID superblock on /dev/sde
>> >> mdadm: no RAID superblock on /dev/sdd
>> >> mdadm: no RAID superblock on /dev/sdc
>> >> mdadm: no RAID superblock on /dev/sdb
>> >> mdadm: no RAID superblock on /dev/sda1
>> >> mdadm: no RAID superblock on /dev/sda
>> >> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 7.
>> >> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 6.
>> >> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
>> >> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
>> >> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
>> >> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
>> >> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
>> >> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
>> >> mdadm: ignoring /dev/sdb1 as it reports /dev/sdi1 as failed
>> >> mdadm: no uptodate device for slot 0 of /dev/md0
>> >> mdadm: added /dev/sdd1 to /dev/md0 as 2
>> >> mdadm: added /dev/sde1 to /dev/md0 as 3
>> >> mdadm: added /dev/sdf1 to /dev/md0 as 4
>> >> mdadm: added /dev/sdg1 to /dev/md0 as 5
>> >> mdadm: added /dev/sdh1 to /dev/md0 as 6
>> >> mdadm: added /dev/sdi1 to /dev/md0 as 7
>> >> mdadm: added /dev/sdc1 to /dev/md0 as 1
>> >> mdadm: /dev/md0 has been started with 6 drives (out of 7) and 1 spare.
>> >>
>> >> I finally made a test by modifying mdadm V3.2.5 sources to not write
>> >> any data to any superblock and to simply exit() somewhere in the
>> >> middle of assembly process to be able to reproduce this behavior
>> >> without any RAID re-creation/synchronization.
>> >> So using mdadm V2.6.4 /dev/md0 assembles without problems and if I
>> >> switch to mdadm V3.2.5 it shows the same messages as above.
>> >>
>> >> The real problem:
>> >> I have more than a single machine receiving a similar software update
>> >> so I need to find a solution or workaround around this problem. By the
>> >> way, from another test without an existing spare disk, there seems to
>> >> be no 'throwing out'-problem when switching from V2.6.4 to V3.2.5.
>> >>
>> >> It would also be a great help if someone could explain the reason
>> >> behind the relevant code fragment for rejecting a device, e.g. why is
>> >> only the 'most_recent' device important?
>> >>
>> >> /* If this device thinks that 'most_recent' has failed, then
>> >>   * we must reject this device.
>> >>   */
>> >> if (j != most_recent &&
>> >>     content->array.raid_disks > 0 &&
>> >>     devices[most_recent].i.disk.raid_disk >= 0 &&
>> >>     devmap[j * content->array.raid_disks +
>> >> devices[most_recent].i.disk.raid_disk] == 0) {
>> >>     if (verbose > -1)
>> >>         fprintf(stderr, Name ": ignoring %s as it reports %s as
>> >> failed\n",
>> >>             devices[j].devname, devices[most_recent].devname);
>> >>     best[i] = -1;
>> >>     continue;
>> >> }
>> >>
>> >> I also attached some files showing some details about related
>> >> superblocks before and after assembly as well as about RAID status
>> >> itself.
>> >
>> >
>> > Thanks for the thorough report.  I think this issue has been fixed in
>> > 3.3-rc1
>> > You can fix it for 3.2.5 by applying the following patch:
>> >
>> > diff --git a/Assemble.c b/Assemble.c
>> > index 227d66f..bc65c29 100644
>> > --- a/Assemble.c
>> > +++ b/Assemble.c
>> > @@ -849,7 +849,8 @@ int Assemble(struct supertype *st, char *mddev,
>> >  		devices[devcnt].i.disk.minor = minor(stb.st_rdev);
>> >  		if (most_recent < devcnt) {
>> >  			if (devices[devcnt].i.events
>> > -			    > devices[most_recent].i.events)
>> > +			    > devices[most_recent].i.events &&
>> > +			    devices[devcnt].i.disk.state == 6)
>> >  				most_recent = devcnt;
>> >  		}
>> >  		if (content->array.level == LEVEL_MULTIPATH)
>> >
>> > The "most recent" device is important as we need to choose one to
>> > compare
>> > all
>> > others again.  The problem is that the code in 3.2.5 can sometimes
>> > choose a
>> > spare, which isn't such a good idea.
>> >
>> > The "most recent" is also important because when a collection of devices
>> > is given to the kernel it will give priority to some information which is
>> > on the
>> > last device passed in.  So we make sure that the last device given to
>> > the kernel is the "most recent".
>> >
>> > Please let me know if the patch fixes your problem.
>> >
>> > NeilBrown
>>
>> First of all, thanks for your very helpful 'most recent disk'
>> explanation.
>>
>> Sadly, the patch didn't fix my problem because the event counters are
>> really equal on all disks (inclusive spare) and the first disk that is
>> checked is the spare disk so there is no reason to set another disk as
>> 'most recent disk', but I improved your patch a little bit by
>> providing more output and created also an own solution, but that needs
>> review because I'm not sure if it can be done like that.
>>
>> Patch 1: Your solution with more output
>> Diff: mdadm-3.2.5-noassemble-patch1.diff
>> Assembly: mdadm-3.2.5-noassemble-patch1.txt
>>
>> Patch 2: My proposed solution
>> Diff: mdadm-3.2.5-noassemble-patch2.diff
>> Assembly: mdadm-3.2.5-noassemble-patch2.txt
>
>
> Thanks for the testing and suggestions.  I see what I missed now.
> Can you check if this patch works please?
>
> Thanks.
> NeilBrown
>
> diff --git a/Assemble.c b/Assemble.c
> index 227d66f..9131917 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -215,7 +215,7 @@ int Assemble(struct supertype *st, char *mddev,
>  	unsigned int okcnt, sparecnt, rebuilding_cnt;
>  	unsigned int req_cnt;
>  	int i;
> -	int most_recent = 0;
> +	int most_recent = -1;
>  	int chosen_drive;
>  	int change = 0;
>  	int inargv = 0;
> @@ -847,8 +847,9 @@ int Assemble(struct supertype *st, char *mddev,
>  		devices[devcnt].i = *content;
>  		devices[devcnt].i.disk.major = major(stb.st_rdev);
>  		devices[devcnt].i.disk.minor = minor(stb.st_rdev);
> -		if (most_recent < devcnt) {
> -			if (devices[devcnt].i.events
> +		if (devices[devcnt].i.disk_state == 6) {
> +			if (most_recent < 0 ||
> +			    devices[devcnt].i.events
>  			    > devices[most_recent].i.events)
>  				most_recent = devcnt;
>  		}

Your patch seems to work without issues.

There is only a small typo:
+		if (devices[devcnt].i.disk_state == 6) {
should be:
+		if (devices[devcnt].i.disk.state == 6) {

I attached the patch that I'm finally using to this mail.
Thank you very much for your help.

--001a11c37be454f76a04e5a47d20
Content-Type: application/octet-stream; name="no-spare-as-most_recent.patch"
Content-Disposition: attachment; filename="no-spare-as-most_recent.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBtZGFkbS0zLjIuNS1vcmlnL0Fzc2VtYmxlLmMgbWRhZG0tMy4yLjUvQXNzZW1i
bGUuYwotLS0gbWRhZG0tMy4yLjUtb3JpZy9Bc3NlbWJsZS5jCTIwMTItMDUtMTggMDk6MTA6MDMu
MDAwMDAwMDAwICswMjAwCisrKyBtZGFkbS0zLjIuNS9Bc3NlbWJsZS5jCTIwMTMtMDktMDMgMTQ6
MDU6NDUuMDAwMDAwMDAwICswMjAwCkBAIC0yMTUsNyArMjE1LDcgQEAKIAl1bnNpZ25lZCBpbnQg
b2tjbnQsIHNwYXJlY250LCByZWJ1aWxkaW5nX2NudDsKIAl1bnNpZ25lZCBpbnQgcmVxX2NudDsK
IAlpbnQgaTsKLQlpbnQgbW9zdF9yZWNlbnQgPSAwOworCWludCBtb3N0X3JlY2VudCA9IC0xOwog
CWludCBjaG9zZW5fZHJpdmU7CiAJaW50IGNoYW5nZSA9IDA7CiAJaW50IGluYXJndiA9IDA7CkBA
IC04NDcsOCArODQ3LDkgQEAKIAkJZGV2aWNlc1tkZXZjbnRdLmkgPSAqY29udGVudDsKIAkJZGV2
aWNlc1tkZXZjbnRdLmkuZGlzay5tYWpvciA9IG1ham9yKHN0Yi5zdF9yZGV2KTsKIAkJZGV2aWNl
c1tkZXZjbnRdLmkuZGlzay5taW5vciA9IG1pbm9yKHN0Yi5zdF9yZGV2KTsKLQkJaWYgKG1vc3Rf
cmVjZW50IDwgZGV2Y250KSB7Ci0JCQlpZiAoZGV2aWNlc1tkZXZjbnRdLmkuZXZlbnRzCisJCWlm
IChkZXZpY2VzW2RldmNudF0uaS5kaXNrLnN0YXRlID09IDYpIHsKKwkJCWlmIChtb3N0X3JlY2Vu
dCA8IDAgfHwKKwkJCSAgICBkZXZpY2VzW2RldmNudF0uaS5ldmVudHMKIAkJCSAgICA+IGRldmlj
ZXNbbW9zdF9yZWNlbnRdLmkuZXZlbnRzKQogCQkJCW1vc3RfcmVjZW50ID0gZGV2Y250OwogCQl9
Cg==
--001a11c37be454f76a04e5a47d20--
